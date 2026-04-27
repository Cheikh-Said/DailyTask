% Utility predicates: normalization, similarity, scoring helpers

% ── Keyword similarity via shared hypernym ─────────────────
% keyword_similarity(K1, K2, Score) — 1.0 = identical, 0.5 = related, 0.0 = unrelated
keyword_similarity(K, K, 1.0) :- !.

keyword_similarity(K1, K2, 0.5) :- related(K1, K2), !.
keyword_similarity(K1, K2, 0.5) :- related(K2, K1), !.

keyword_similarity(_, _, 0.0).

% ── Related keyword pairs (symmetric) ──────────────────────
related(nlp, transformer).
related(nlp, seq2seq).
related(nlp, attention).
related(nlp, bert).
related(nlp, gpt3).
related(nlp, language_model).
related(nlp, word2vec).
related(nlp, glove).
related(nlp, embedding).
related(nlp, machine_translation).
related(nlp, few_shot).
related(deep_learning, cnn).
related(deep_learning, rnn).
related(deep_learning, transformer).
related(deep_learning, gan).
related(deep_learning, lstm).
related(deep_learning, neural_network).
related(deep_learning, resnet).
related(deep_learning, vgg).
related(deep_learning, alexnet).
related(deep_learning, vision_transformer).
related(deep_learning, gnn).
related(deep_learning, graph_neural_network).
related(deep_learning, diffusion).
related(deep_learning, score_matching).
related(computer_vision, cnn).
related(computer_vision, object_detection).
related(computer_vision, yolo).
related(computer_vision, faster_rcnn).
related(computer_vision, vgg).
related(computer_vision, resnet).
related(computer_vision, alexnet).
related(computer_vision, vision_transformer).
related(reinforcement_learning, q_learning).
related(reinforcement_learning, dqn).
related(reinforcement_learning, ppo).
related(reinforcement_learning, policy_gradient).
related(reinforcement_learning, atari).
related(reinforcement_learning, alpha_go).
related(reinforcement_learning, game_ai).
related(optimization, adam).
related(optimization, gradient_descent).
related(optimization, batch_norm).
related(optimization, dropout).
related(optimization, regularization).
related(generative, gan).
related(generative, diffusion).
related(generative, rnn).
related(transfer_learning, domain_adaptation).
related(transfer_learning, pretraining).
related(transfer_learning, few_shot).
related(embedding, representation_learning).
related(embedding, word2vec).
related(embedding, glove).
related(seq2seq, attention).
related(seq2seq, machine_translation).
related(seq2seq, lstm).
related(cnn, resnet).
related(cnn, vgg).
related(cnn, alexnet).
related(cnn, faster_rcnn).
related(cnn, yolo).
related(object_detection, faster_rcnn).
related(object_detection, yolo).
related(transformer, attention).
related(transformer, bert).
related(transformer, gpt3).
related(transformer, vision_transformer).

% ── Score keyword match ────────────────────────────────────
% score_keyword_match(UserKeyword, PaperKeyword, Score)
% Uses similarity and weight
score_keyword_match(UK, PK, Score) :-
    normalize_keyword(UK, NK),
    keyword_similarity(NK, PK, Sim),
    keyword_weight(PK, W),
    Score is Sim * W.

% ── List helpers ───────────────────────────────────────────
list_intersection([], _, []).
list_intersection([H|T], L2, [H|R]) :-
    memberchk(H, L2), !,
    list_intersection(T, L2, R).
list_intersection([_|T], L2, R) :-
    list_intersection(T, L2, R).

list_union([], L, L).
list_union([H|T], L2, R) :-
    memberchk(H, L2), !,
    list_union(T, L2, R).
list_union([H|T], L2, [H|R]) :-
    list_union(T, L2, R).

min_length(L, Min) :-
    length(L, N),
    N >= Min.
