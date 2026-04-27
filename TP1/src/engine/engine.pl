% Inference engine: recommend, recommend_list, rank_papers
% Core entry points for the expert system

% ── recommend(UserID, PaperID) ────────────────────────────
% Succeeds if PaperID is recommended for UserID (score > 0)
recommend(UserID, PaperID) :-
    user(UserID, _, _, _),
    paper(PaperID, _, _, _, _),
    apply_all_rules(UserID, PaperID, Score),
    Score > 0.

% ── recommend_list(UserID, ListOfPapers) ─────────────────
% Returns all recommended papers (unsorted)
recommend_list(UserID, List) :-
    findall(PaperID, recommend(UserID, PaperID), List).

% ── rank_papers(UserID, SortedResults) ───────────────────
% Returns papers sorted by descending score
rank_papers(UserID, Sorted) :-
    findall(Score-PaperID,
        (paper(PaperID, _, _, _, _),
         apply_all_rules(UserID, PaperID, Score),
         Score > 0),
        Unsorted),
    rank_by_score(Unsorted, Sorted).

% ── rank_papers_top_n(UserID, N, TopN) ───────────────────
rank_papers_top_n(UserID, N, TopN) :-
    rank_papers(UserID, Sorted),
    length(TopN, N),
    append(TopN, _, Sorted).

% ── Dynamic updates ──────────────────────────────────────
add_paper(ID, Title, Keywords, Year, Authors) :-
    asserta(paper(ID, Title, Keywords, Year, Authors)).

add_user(ID, Interests, PreferredAuthors, ExcludedTopics) :-
    asserta(user(ID, Interests, PreferredAuthors, ExcludedTopics)).

add_feedback(UserID, PaperID) :-
    asserta(feedback(UserID, PaperID)).

% ── Persistence ───────────────────────────────────────────
save_data :-
    open('data/runtime/data.pl', write, Stream),
    write(Stream, '% Auto-saved runtime data\n\n'),
    forall(paper(ID, T, K, Y, A),
           (write(Stream, 'paper('),
            write(Stream, ID), write(Stream, ', '),
            writeq(Stream, T), write(Stream, ', '),
            writeq(Stream, K), write(Stream, ', '),
            write(Stream, Y), write(Stream, ', '),
            writeq(Stream, A), write(Stream, ').\n'))),
    nl(Stream),
    forall(user(ID, I, PA, E),
           (write(Stream, 'user('),
            write(Stream, ID), write(Stream, ', '),
            writeq(Stream, I), write(Stream, ', '),
            writeq(Stream, PA), write(Stream, ', '),
            writeq(Stream, E), write(Stream, ').\n'))),
    nl(Stream),
    forall(feedback(U, P),
           (write(Stream, 'feedback('),
            write(Stream, U), write(Stream, ', '),
            write(Stream, P), write(Stream, ').\n'))),
    close(Stream),
    writeln('Data saved to data/runtime/data.pl').

load_data :-
    exists_file('data/runtime/data.pl'),
    consult('data/runtime/data.pl'),
    writeln('Data loaded from data/runtime/data.pl'),
    !.
load_data :-
    writeln('No runtime data file found; using defaults.').
