% REST API using SWI-Prolog HTTP library
% Endpoints: /recommend, /add_paper, /add_user

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).
:- use_module(library(json)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_cors)).

:- set_setting(http:cors, [*]).

% ── Route declarations ────────────────────────────────────
:- http_handler(root(recommend), handle_recommend, []).
:- http_handler(root(add_paper), handle_add_paper, []).
:- http_handler(root(add_user), handle_add_user, []).
:- http_handler(root(rank), handle_rank, []).
:- http_handler(root(add_feedback), handle_add_feedback, []).
:- http_handler(root(.), serve_files_in_directory(web), [prefix]).

% ── Start server ──────────────────────────────────────────
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]),
    format('Server running at http://localhost:~w~n', [Port]).

start_server :-
    start_server(8080).

% ── GET /recommend?user=user1 ─────────────────────────────
handle_recommend(Request) :-
    cors_enable,
    http_parameters(Request, [
        user(User, [atom])
    ]),
    rank_papers(User, ScoredPapers),
    map_scored_to_json(ScoredPapers, JsonList),
    reply_json_dict(_{user: User, recommendations: JsonList}).

% ── GET /rank?user=user1&n=5 ──────────────────────────────
handle_rank(Request) :-
    cors_enable,
    http_parameters(Request, [
        user(User, [atom]),
        n(N, [integer, default(5)])
    ]),
    rank_papers_top_n(User, N, TopN),
    map_scored_to_json(TopN, JsonList),
    reply_json_dict(_{user: User, top_n: N, results: JsonList}).

% ── GET /add_paper?id=p26&title=...&keywords=...&year=2022&authors=... ──
handle_add_paper(Request) :-
    cors_enable,
    http_parameters(Request, [
        id(ID, [atom]),
        title(Title, [atom]),
        keywords(KwStr, [atom]),
        year(Year, [integer]),
        authors(AuthStr, [atom])
    ]),
    atom_split(KwStr, ',', Keywords),
    atom_split(AuthStr, ',', Authors),
    add_paper(ID, Title, Keywords, Year, Authors),
    reply_json_dict(_{status: ok, action: add_paper, id: ID}).

% ── GET /add_user?id=user8&interests=...&authors=...&excluded=... ────────
handle_add_user(Request) :-
    cors_enable,
    http_parameters(Request, [
        id(ID, [atom]),
        interests(IntStr, [atom]),
        authors(AuthStr, [atom, default('')]),
        excluded(ExclStr, [atom, default('')])
    ]),
    atom_split(IntStr, ',', Interests),
    (AuthStr = '' -> PreferredAuthors = [] ; atom_split(AuthStr, ',', PreferredAuthors)),
    (ExclStr = '' -> ExcludedTopics = [] ; atom_split(ExclStr, ',', ExcludedTopics)),
    add_user(ID, Interests, PreferredAuthors, ExcludedTopics),
    reply_json_dict(_{status: ok, action: add_user, id: ID}).

% ── GET /add_feedback?user=user1&paper=p1 ────────────────
handle_add_feedback(Request) :-
    cors_enable,
    http_parameters(Request, [
        user(User, [atom]),
        paper(Paper, [atom])
    ]),
    add_feedback(User, Paper),
    reply_json_dict(_{status: ok, action: add_feedback, user: User, paper: Paper}).

% ── Helpers ───────────────────────────────────────────────
map_scored_to_json([], []).
map_scored_to_json([Score-PaperID|Rest], [Entry|JsonRest]) :-
    paper(PaperID, Title, Keywords, Year, Authors),
    Entry = _{paper_id: PaperID, title: Title, keywords: Keywords,
              year: Year, authors: Authors, score: Score},
    map_scored_to_json(Rest, JsonRest).

atom_split(Atom, Sep, Parts) :-
    atomic_list_concat(Parts, Sep, Atom).
