%p2.pl
%Student: Zachary Reese
%Major: Computer Science
%Creation Date: 10/25/2024
%Due Date: 10/30/2024 @ 5am
%CPSC 447 Artificial Intelligence I
%Professor: Dr. Schwesinger
%Assignment: Prolog Project 2
%Description: This project uses predicates to represent a pre-defined tree used with the predicates to determine if two nodes of the tree are ancestors,
  %descendants, siblings, and/ or at the same level/ depth. Recursive rule calls are applied here within ancestor and level rules.

%Tree structure represented by predicates
root(a). %level/ depth 0
parent(a, b).
parent(a, c).
parent(a, d).
parent(b, e).
parent(b, f).
parent(f, l).
parent(f, m).
parent(m, t).
parent(c, g).
parent(c, h).
parent(c, i).
parent(h, n).
parent(i, o).
parent(i, p).
parent(d, j).
parent(j, q).
parent(j, r).
parent(j, s).

%The ancestor predicate determines if Ancestor is an ancestor of Descendant by recursively checking if Ancestor is the parent of Descendant,
  %or if Ancestor is the parent of an IntermediateChild which has been confirmed as an ancestor of Descendant by the recursive chain.
ancestor(Ancestor, Descendant) :-
	parent(Ancestor, Descendant). %if false, move onto recursive step. if true, end recursive steps.
ancestor(Ancestor, Descendant) :-
	parent(Ancestor, IntermediateChild),
	ancestor(IntermediateChild, Descendant).

%The descendant predicate determines if Descendant is a descendant of Ancestor.
descendant(Ancestor, Descendant) :-
	ancestor(Descendant, Ancestor).

%The sibling predicate determines whether two nodes of the tree share the same parent.
sibling(Node1, Node2) :-
	Node1 \= Node2, %short circuit evaluation if the nodes are identical
	parent(Parent, Node1),
	parent(Parent, Node2).

%The level rule is a helper rule for same_level and returns the level/ depth of the Node in question.
level(Node, 0) :-
	root(Node).
level(Node, Depth) :-
	parent(Parent, Node),
	level(Parent, ParentDepth),
	Depth is ParentDepth + 1. %accumulating after recursive call excludes counting the root level before returning

%The same_level rule determines whether two nodes of the tree are on the same level/ depth. If two nodes entered are identical, 
  %it returns True rather than erroring to False.
same_level(Node1, Node2) :-
	level(Node1, Depth),
	level(Node2, Depth).