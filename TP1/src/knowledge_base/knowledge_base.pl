% Knowledge base: dynamic declarations, users, feedback, normalization, weights
% Papers are loaded from data/processed/papers.pl

% Dynamic predicates — support assert/retract at runtime
:- dynamic paper/5.
:- dynamic user/4.
:- dynamic feedback/2.

% ── Keyword normalization map ──────────────────────────────
% normalize_keyword(Raw, Canonical)
normalize_keyword(ml, machine_learning).
normalize_keyword(dl, deep_learning).
normalize_keyword(rl, reinforcement_learning).
normalize_keyword(cv, computer_vision).
normalize_keyword(nn, neural_network).
normalize_keyword(K, K) :- atom(K), \+ abbreviation(K), !.

abbreviation(ml).
abbreviation(dl).
abbreviation(rl).
abbreviation(cv).
abbreviation(nn).

% ── Keyword weights (importance scoring) ────────────────────
% More specific/rare keywords get higher weight
keyword_weight(transformer, 3).
keyword_weight(attention, 3).
keyword_weight(reinforcement_learning, 3).
keyword_weight(gpt3, 3).
keyword_weight(alpha_go, 2).
keyword_weight(object_detection, 2).
keyword_weight(vision_transformer, 3).
keyword_weight(diffusion, 3).
keyword_weight(graph_neural_network, 2).
keyword_weight(few_shot, 3).
keyword_weight(deep_learning, 1).
keyword_weight(nlp, 1).
keyword_weight(cnn, 1).
keyword_weight(optimization, 1).
keyword_weight(transfer_learning, 2).
keyword_weight(survey, 1).
keyword_weight(embedding, 2).
keyword_weight(generative, 2).
keyword_weight(K, 1) :- atom(K), \+ weighted_keyword(K), !.

weighted_keyword(transformer).
weighted_keyword(attention).
weighted_keyword(reinforcement_learning).
weighted_keyword(gpt3).
weighted_keyword(alpha_go).
weighted_keyword(object_detection).
weighted_keyword(vision_transformer).
weighted_keyword(diffusion).
weighted_keyword(graph_neural_network).
weighted_keyword(few_shot).
weighted_keyword(deep_learning).
weighted_keyword(nlp).
weighted_keyword(cnn).
weighted_keyword(optimization).
weighted_keyword(transfer_learning).
weighted_keyword(survey).
weighted_keyword(embedding).
weighted_keyword(generative).

% ── User facts (7 users) ────────────────────────────────────
user(user1,
    [nlp, transformer, deep_learning],
    [vaswani, devlin],
    [game_ai]).

user(user2,
    [computer_vision, cnn, object_detection],
    [he, ren],
    [nlp]).

user(user3,
    [reinforcement_learning, deep_learning, optimization],
    [silver, schulman],
    [survey]).

user(user4,
    [nlp, embedding, representation_learning],
    [mikolov, pennington],
    [game_ai, atari]).

user(user5,
    [deep_learning, generative, optimization, regularization],
    [goodfellow, kingma],
    [survey]).

user(user6,
    [transfer_learning, machine_learning, domain_adaptation, survey],
    [pan, yang],
    [atari, game_ai]).

user(user7,
    [deep_learning, transformer, computer_vision, gnn],
    [dosovitskiy, zhou],
    []).

% ── Feedback facts (user → disliked paper) ──────────────────
feedback(user1, p7).   % user1 disliked the AlphaGo paper
feedback(user2, p20).  % user2 disliked the transfer learning survey
feedback(user3, p6).   % user3 disliked the Atari paper
feedback(user5, p3).   % user5 disliked the GAN paper
