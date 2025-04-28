# search.py
# Student: Zachary Reese
# Major: Computer Science
# Creation Date: 9/14/24
# Due Date: 9/27 @ 5am
# CPSC 447 Artificial Intelligence I
# Professor: PROFESSOR_NAME_REDACTED
# Assignment: Project 1
# Description: I (student) am to fill in search algorithms for use throughout the project. Algorithms include DFS, BFS, UCS, and A* searches.
#   This file in particular makes use of custom data structures pre-defined in util.py, such as the stack, queue, and priority queue.
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util
from game import Directions

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    s = Directions.SOUTH
    w = Directions.WEST
    print("Start:", problem.getStartState())
    print("Is the start a goal?", problem.isGoalState(problem.getStartState()))
    print("Start's successors:", problem.getSuccessors(problem.getStartState()))
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem: SearchProblem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print("Start:", problem.getStartState())
    print("Is the start a goal?", problem.isGoalState(problem.getStartState()))
    print("Start's successors:", problem.getSuccessors(problem.getStartState()))
    """
    from util import Stack

    stack = util.Stack()
    start_state = problem.getStartState()
    stack.push((start_state, [])) #add the initial start state to the stack along with its actions (moveset) to get there
    visited = set()

    while not stack.isEmpty():
        current_state, actions = stack.pop()

        if problem.isGoalState(current_state):
            return actions
        
        if current_state not in visited:
            visited.add(current_state)
                                 #\/ cost, always 1
            for successor, action, _ in problem.getSuccessors(current_state): #_ is cost
                if successor not in visited:
                    stack.push((successor, actions + [action]))
    
    print("ERRORz: depthFirstSearch is to return an empty list in search.py!")
    return [] #if nothing is found, return empty list


def breadthFirstSearch(problem: SearchProblem):
    """Search the shallowest nodes in the search tree first."""
    from util import Queue

    queue = util.Queue()
    start_state = problem.getStartState()
    queue.push((start_state, [])) #add the initial start state to the queue along with its actions (moveset) to get there
    visited = set()

    while not queue.isEmpty():
        current_state, actions = queue.pop()
        #print("Visiting:", current_state)

        if problem.isGoalState(current_state):
            return actions
            #return [getDirection(action) for action in actions] #convert the string actions (NS-EW) to a list of game directions

        #if current_state not in visited:
        #    visited.add(current_state)
        if current_state in visited:
            continue
        visited.add(current_state)

        for successor, action, _ in problem.getSuccessors(current_state):
            if successor not in visited: #this line isn't necessary, but still here to help with processing efficiency
                queue.push((successor, actions + [action]))
        
    print("ERRORz: breadthFirstSearch is to return an empty list in search.py!")
    return []  # If nothing is found, return an empty list

def uniformCostSearch(problem: SearchProblem):
    """Search the node of least total cost first."""
    from util import PriorityQueue

    priority_queue = util.PriorityQueue()
    start_state = problem.getStartState()
    priority_queue.push((start_state, [], 0), 0) #add the initial start state to the queue along with its actions (moveset) to get there
    visited = {} #dictionary

    while not priority_queue.isEmpty():
        current_state, actions, cumulative_cost = priority_queue.pop()
        
        if problem.isGoalState(current_state):
            return actions
            #return [getDirection(action) for action in actions] #convert the string actions (NS-EW) to a list of game directions
        
        if current_state not in visited or cumulative_cost < visited[current_state]:
            visited[current_state] = cumulative_cost

            for successor, action, step_cost in problem.getSuccessors(current_state):
                new_cost = cumulative_cost + step_cost
                priority_queue.update((successor, actions + [action], new_cost), new_cost)

    print("ERRORz: uniformCostSearch is to return an empty list in search.py!")
    return []  # If nothing is found, return an empty list

def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem: SearchProblem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    from util import PriorityQueue

    priority_queue = util.PriorityQueue()
    start_state = problem.getStartState()
    priority_queue.push((start_state, [], 0), 0) #add the initial start state to the queue along with its actions (moveset) to get there
    visited = {} #dictionary

    while not priority_queue.isEmpty():
        current_state, actions, cumulative_cost = priority_queue.pop()
        
        if problem.isGoalState(current_state):
            return actions
            #return [getDirection(action) for action in actions] #convert the string actions (NS-EW) to a list of game directions
        
        if current_state not in visited or cumulative_cost < visited[current_state]:
            visited[current_state] = cumulative_cost

            for successor, action, step_cost in problem.getSuccessors(current_state):
                new_cost = cumulative_cost + step_cost
                total_cost = new_cost + heuristic(successor, problem)
                priority_queue.update((successor, actions + [action], new_cost), total_cost)

    print("ERRORz: aStarSearch is to return an empty list in search.py!")
    return []  # If nothing is found, return an empty list


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch


def getDirection(action):
    if action == 'North':
        return Directions.NORTH
    elif action == 'South':
        return Directions.SOUTH
    elif action == 'East':
        return Directions.EAST
    elif action == 'West':
        return Directions.WEST
    print("ERRORz: invalid direction to be returned from getDirection function in search.py!")
    return None #invalid direction!