% Main entry point — loads all modules and provides interactive REPL
% Usage: swipl src/main.pl   (from project root)

:- prolog_load_context(directory, SrcDir),
   atom_concat(SrcDir, '/../', ProjectRootRel),
   absolute_file_name(ProjectRootRel, ProjectRoot),
   working_directory(_, ProjectRoot),
   asserta(user:file_search_path(project, ProjectRoot)).

:- initialization(main).

main :-
    load_files([
        project('src/knowledge_base/knowledge_base'),
        project('data/processed/papers'),
        project('src/utils/utils'),
        project('src/rules/rules'),
        project('src/engine/engine'),
        project('src/api/api')
    ], [silent(true)]),
    writeln('hello in prolog TP1'),
    writeln(''),
    writeln('Example queries:'),
    writeln('  ?- recommend(user1, P).'),
    writeln('  ?- recommend_list(user1, L).'),
    writeln('  ?- rank_papers(user1, R).'),
    writeln('  ?- rank_papers_top_n(user1, 3, Top).'),
    writeln('  ?- save_data.'),
    writeln('  ?- load_data.'),
    writeln('  ?- start_server(8080).'),
    writeln(''),
    % Start REPL if running interactively
    (current_prolog_flag(argv, [_|_]) -> true ; true).
