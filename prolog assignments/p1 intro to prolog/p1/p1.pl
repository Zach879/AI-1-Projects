%p1.pl
%Student: Zachary Reese
%Major: Computer Science
%Creation Date: 10/22/2024
%Due Date: 10/23/2024 @ 5am
%CPSC 447 Artificial Intelligence I
%Professor: PROFESSOR_NAME_REDACTED
%Assignment: Prolog Project 1
%Description: Intro to prolog assignment which runs queries on rules using predefined facts and a user defined fact.

%facts
vampire(dio).
plays_rugby(jonathan).

%rules
nocturnal(X) :- vampire(X).

likes(tarkus, X) :- nocturnal(X).
likes(george, X) :- nocturnal(X); plays_rugby(X).