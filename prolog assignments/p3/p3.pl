%p3.pl
%Student: Zachary Reese
%Major: Computer Science
%Creation Date: 11/01/2024
%Due Date: 11/06/2024 @ 5am
%CPSC 447 Artificial Intelligence I
%Professor: PROFESSOR_NAME_REDACTED
%Assignment: Prolog Project 3
%Description: This file implements recursive rules to perform arithmetic and to traverse lists to extract data.

%factorial rule computes the factorial of a non-negative number and places the computation within Result.
%base case: N = 0 returns 1. Ends recursive calls and begins recursive stack processing.
factorial(0, 1).
%recursive case: handles recursive processing for 1 to N.
factorial(N, Result) :-
	N > 0, %prevent indefinite negative recursion
	SubN is N - 1,
	factorial(SubN, SubResult),
	Result is N * SubResult.

%nth rule retrieves the nth element from List and places the extracted element in Elt.
%base case: N = 0 begins the recursive case if Elt isn't element 0.
nth(0, [Elt | _], Elt).
%recursive case: Searches
nth(N, [_ | RemainingList], Elt) :-
	N > 0, %prevent indefinite negative recursion
	SubN is N - 1,
	nth(SubN, RemainingList, Elt). %drops recursive process stack once element is found.

%search list of property, value pairs for matching pairs and return true if both values given to find are found
  %as a pair, or returns the other (missing) part of the pair.
%preliminary check: empty list causes rule to fail
assoc(_, [], _) :- false.
%base case: property, value pair with a matching value was found somewhere as the starting value in the (sub) list.
assoc(Property, [[Property, Value] | _], Value).
%recursive case: search rest of list for matching ordered pair data.
assoc(Property, [_ | RemainingList], Value) :-
	assoc(Property, RemainingList, Value). %continue searching