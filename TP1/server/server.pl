% Server entry point — start the HTTP API server
% Usage: swipl server/server.pl          (from project root)
%    or:  swipl server/server.pl -- 9090  (custom port)

:- prolog_load_context(directory, ServerDir),
   atom_concat(ServerDir, '/../', ProjectRootRel),
   absolute_file_name(ProjectRootRel, ProjectRoot),
   working_directory(_, ProjectRoot),
   asserta(user:file_search_path(project, ProjectRoot)).

:- load_files([
    project('src/knowledge_base/knowledge_base'),
    project('data/processed/papers'),
    project('src/utils/utils'),
    project('src/rules/rules'),
    project('src/engine/engine'),
    project('src/api/api')
], [silent(true)]).

:- initialization(run_server).

run_server :-
    current_prolog_flag(argv, [PortAtom|_]),
    atom_number(PortAtom, Port), !,
    start_server(Port).
run_server :-
    start_server(8080).
