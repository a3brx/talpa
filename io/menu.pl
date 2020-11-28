:- consult('read.pl').
:- consult('ask.pl').
:- consult('titles.pl').
:- consult('../utils/utils.pl').

handle_main_menu(Level_X-Level_O) :-
	clear,
    display_main_menu,
    requestOption(1, 2),
    getIntInterval(1, 2, Option),
    handle_main_menu_options(Option, Level_X-Level_O),
    clear.

handle_main_menu_options(1, Level) :- !,
        handle_level_menu(Level).
handle_main_menu_option(2, _):-
        halt. 

handle_level_menu(Level_X-Level_O):-
        display_level_menu(1),
        requestLevel(1, 9),
        getIntInterval(0, 9, Level_X),
        display_level_menu(2),
        requestLevel(1, 9),
	    getIntInterval(0, 9, Level_O).

% ----------------------------------------------- 
% Main menu
% -----------------------------------------------
display_main_menu :-
        display_title(main),
        display_main_options,
        menu_delimitation_bottom.

display_main_options :-
	language(Language),
	menuOptionPlay(Language, OptionPlay),
	menuOptionSettings(Language, OptionSettings),
	menuOptionExit(Language, OptionExit),
	formatToMenu('\x2502\       1) ', OptionPlay, []),
	formatToMenu('\x2502\       2) ', OptionSettings, []),
	formatToMenu('\x2502\       3) ', OptionExit, []).
        
% ----------------------------------------------- 
%  Level Menu        
% -----------------------------------------------
display_level_menu(Player) :-
	display_title(level),
	display_level_options(Player),
	menu_delimitation_bottom.

display_level_options(Player) :-
	code(Player, Code),
	language(Language),

    menuConfigurationsForPlayer(Language, ConfigString),
    menuPlayAsHuman(Language, HumanString),
    menuChooseBotLevel(Language, BotString),
    menuOneDigitFirstLine(Language, OneDigitString1),
    menuOneDigitSecondLine(Language, OneDigitString2),
    menuRandomBot(Language, RandomString),

    formatToMenu(ConfigString, [Code]),
    menu_empty_line,
    formatToMenu(HumanString, [0]),
    formatToMenu(BotString, [1, 9]),
    formatToMenu(OneDigitString1),
    formatToMenu('\x2502\    ', OneDigitString2, []),
    formatToMenu(RandomString, [1]).

% -----------------------------------------------
% Normalize size of string
% -----------------------------------------------
createChars(0, _, '') :- !.
createChars(N, C, Result) :-
	N1 is N - 1,
	createChars(N1, C, Aux),
	atom_concat(C, Aux, Result).

centralize(String, N, Normalizer, NormalizedString) :-
	atom_length(String, L),
	Dif is N - L,
	Right is Dif // 2 + Dif mod 2,
	Left is Dif // 2,
	createChars(Right, Normalizer, RightString),
	createChars(Left, Normalizer, LeftString),
	atom_concat(String, RightString, NormalizedStringAux),
	atom_concat(LeftString, NormalizedStringAux, NormalizedString).

normalize(String, N, Normalizer, NormalizedString) :-
	atom_length(String, L),
	Right is N - L,
	createChars(Right, Normalizer, RightString),
	atom_concat(String, RightString, NormalizedString).

formatToMenu(Start, End, Normalizer, String, List) :-
	atom_chars(String, Chars),
	ocurrenceOf(Chars, '~', X),
	atom_length(Start, StartLength),
	N is 50 + X - StartLength,
	normalize(String, N, Normalizer, NewString),
	atom_concat(Start, NewString, AuxResult),
	atom_concat(AuxResult, End, Result),
	format(Result, List).

formatToMenu(Start, End, String, List) :-
	formatToMenu(Start, End, ' ', String, List).

formatToMenu(Start, String, List) :-
	formatToMenu(Start, '\x2502\\n', String, List).

formatToMenu(String, List) :-
	formatToMenu('\x2502\  - ', String, List).

formatToMenu(String) :-
	formatToMenu('\x2502\  - ', String, []).

% -----------------------------------------------
% Titles
% -----------------------------------------------
display_title(Name) :-
	menu_delimitation_top,
	menu_empty_line,
    write_title(Name),
    menu_empty_line,
    menu_empty_line,
    menu_empty_line.

write_lines(List) :-
	member(X, List),
	centralize(X, 49, ' ', ToWrite),
	write('\x2502\'),
	write(ToWrite),
	write('\x2502\'), nl,
	fail.

write_lines(_).

write_title(Name) :-
	title(Name, List),
	write_lines(List).

% -----------------------------------------------
% Menu delimitations
% -----------------------------------------------
menu_empty_line :-
	formatToMenu('\x2502\', '', []).

menu_delimitation_top :-
	formatToMenu('\x250C\', '\x2510\\n', '\x2500\', '', []),
	menu_empty_line.

menu_delimitation_bottom :-
	menu_empty_line,
	formatToMenu('\x2514\', '\x2518\\n', '\x2500\', '', []).
