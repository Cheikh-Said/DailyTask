% Rules module — implements all 10 inference rules
% Each rule produces a score for a (User, Paper) pair

% ── Rule 1: Keyword matching ───────────────────────────────
% Score = number of matching keywords between user interests and paper keywords
rule_keyword_match(UserID, PaperID, Score) :-
    user(UserID, Interests, _, _),
    paper(PaperID, _, Keywords, _, _),
    list_intersection(Interests, Keywords, Matches),
    length(Matches, Score),
    Score > 0.

% ── Rule 2: Year filter ───────────────────────────────────
% Score = 1 if paper year >= MinYear, 0 otherwise
rule_year_filter(_UserID, PaperID, MinYear, Score) :-
    paper(PaperID, _, _, Year, _),
    (Year >= MinYear -> Score = 1 ; Score = 0).

% ── Rule 3: Author preference ──────────────────────────────
% Score = number of preferred authors present in paper
rule_author_pref(UserID, PaperID, Score) :-
    user(UserID, _, PreferredAuthors, _),
    paper(PaperID, _, _, _, Authors),
    list_intersection(PreferredAuthors, Authors, Matches),
    length(Matches, Score),
    Score > 0.

% ── Rule 4: Multi-criteria (keywords + year) ──────────────
% Score = keyword_matches if year >= MinYear, else 0
rule_multi_criteria(UserID, PaperID, MinYear, Score) :-
    rule_keyword_match(UserID, PaperID, KwScore),
    rule_year_filter(UserID, PaperID, MinYear, YearScore),
    Score is KwScore * YearScore.

% ── Rule 5: Exclusion ─────────────────────────────────────
% Score = 0 if any excluded topic matches paper keyword, else 1
rule_exclusion(UserID, PaperID, Score) :-
    user(UserID, _, _, Excluded),
    paper(PaperID, _, Keywords, _, _),
    list_intersection(Excluded, Keywords, Conflicts),
    (Conflicts = [] -> Score = 1 ; Score = 0).

% ── Rule 6: Top-N recommendation ─────────────────────────
% Returns top N papers by score from a scored list
rule_top_n(_UserID, N, SortedResults, TopN) :-
    rank_by_score(SortedResults, Ranked),
    length(TopN, N),
    append(TopN, _, Ranked).

% ── Rule 7: Keyword weighting + scoring ──────────────────
% Weighted score: sum of (similarity * weight) for best match per user keyword
rule_keyword_scoring(UserID, PaperID, Score) :-
    user(UserID, Interests, _, _),
    paper(PaperID, _, Keywords, _, _),
    findall(S,
        (member(UK, Interests),
         member(PK, Keywords),
         score_keyword_match(UK, PK, S)),
        Scores),
    sum_list(Scores, Score),
    Score > 0.

% ── Rule 8: Min 2 keyword matches ────────────────────────
% Score = keyword count if >= MinMatches, else 0
rule_min_matches(UserID, PaperID, MinMatches, Score) :-
    rule_keyword_match(UserID, PaperID, KwScore),
    (KwScore >= MinMatches -> Score = KwScore ; Score = 0).

% ── Rule 9: Exclude old papers ───────────────────────────
% Score = 1 if year >= CutoffYear, else 0
rule_exclude_old(PaperID, CutoffYear, Score) :-
    paper(PaperID, _, _, Year, _),
    (Year >= CutoffYear -> Score = 1 ; Score = 0).

% ── Rule 10: User feedback (ignore disliked) ─────────────
% Score = 0 if user gave negative feedback on paper, else 1
rule_feedback(UserID, PaperID, Score) :-
    (feedback(UserID, PaperID) -> Score = 0 ; Score = 1).

% ── Composite: apply all rules and produce final score ───
apply_all_rules(UserID, PaperID, FinalScore) :-
    rule_keyword_match(UserID, PaperID, KwScore),
    rule_exclusion(UserID, PaperID, ExclScore),
    rule_feedback(UserID, PaperID, FbScore),
    rule_exclude_old(PaperID, 2012, OldScore),
    rule_keyword_scoring(UserID, PaperID, WeightedScore),
    FinalScore is (KwScore * 2) + ExclScore + FbScore + OldScore + WeightedScore.

% ── Helper: rank list of Scored-PaperID pairs ────────────
rank_by_score(List, Ranked) :-
    findall(NS-PID, (member(S-PID, List), NS is -S), Negated),
    keysort(Negated, Sorted),
    findall(S-PID, (member(NS-PID, Sorted), S is -NS), Ranked).
