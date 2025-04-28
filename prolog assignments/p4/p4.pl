%p3.pl
%Student: Zachary Reese
%Major: Computer Science
%Creation Date: 11/08/2024
%Due Date: 11/15/2024 @ 5am
%CPSC 447 Artificial Intelligence I
%Professor: PROFESSOR_NAME_REDACTED
%Assignment: Prolog Project 4
%Description: This project implements add, remove, sum, and max (tail recursively) predicates using the prolog defined fail and cut (!) predicates,
  %as well as the custom defined helper predicates of notmember and init_max.

%notmember predicate uses cut and fail predicates to determine if Element is an element within List.
notmember(_, []) :- !.
notmember(Element, [Element|_]) :- !, fail.
notmember(Element, [_|Tail]) :-
	notmember(Element, Tail).

%add predicate uses the prolog interpreter's pattern recognition to create a new version of InList with Element pushed into the front of the list,
  %only if it doesn't already exist in the list.
add(Element, InList, [Element|InList]) :-
	notmember(Element, InList), !.
add(_, InList, InList).

%remove predicate removes only the first occurrence of element in InList only if it exists in Inlist, with the help of the cut predicate.
remove(Element, InList, InList) :-
	notmember(Element, InList), !.
remove(Element, [Element|Tail], Tail) :- !.
remove(Element, [Head|Tail], [Head|NewTail]) :-
	remove(Element, Tail, NewTail).

%sum predicate determines, for each element with the user given list, if the element matches the types of integer, atom, or float, and accumulate
  %accordingly, with the help of cut.
sum([], 0) :- !. %cut added here for efficiency
sum([Head|Tail], Result) :-
	integer(Head), !,
	sum(Tail, TailSum),
	Result is Head + TailSum.
sum([Head|Tail], Result) :-
	atom(Head), !,
	sum(Tail, TailSum),
	Result is 1 + TailSum.
sum([Head|Tail], Result) :-
	float(Head), !,
	sum(Tail, TailSum),
	Result is TailSum - 1.
sum([_|Tail], Result) :-
	sum(Tail, Result).

%init_max predicate initializes the max recursive predicate by setting its first Element to check automatically as the first element in the list.
  %Without init_max, the user would have to specify the 2nd argument for max predicate, which expects the initial value to be the first element in the list.
  %Note: for this predicate, it didn't seem like you were going to use an autograder on it. But regardless, calling max with the above specified value works.
init_max([Head|Tail], Max) :-
	max(Tail, Head, Max).

%max predicate is initialized by init_max with the first element in the list to find the maximum element in the list using tail recursion,
  %which means that the recursive call within the recursive case occurs after computation as the last line for compiler optimization.
max([], CurrentMax, CurrentMax).
max([Head|Tail], CurrentMax, Max) :-
	(Head >= CurrentMax, !, NewMax = Head ; NewMax = CurrentMax),
	max(Tail, NewMax, Max).