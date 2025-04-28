# multiAgents.py
# --------------
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


from util import manhattanDistance
from game import Directions
import random, util

from game import Agent
from pacman import GameState

class ReflexAgent(Agent):
    """
    A reflex agent chooses an action at each choice point by examining
    its alternatives via a state evaluation function.

    The code below is provided as a guide.  You are welcome to change
    it in any way you see fit, so long as you don't touch our method
    headers.
    """


    def getAction(self, gameState: GameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {NORTH, SOUTH, WEST, EAST, STOP}
        """
        # Collect legal moves and successor states
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
        chosenIndex = random.choice(bestIndices) # Pick randomly among the best

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]

    def evaluationFunction(self, currentGameState: GameState, action):
        """
        Design a better evaluation function here.

        The evaluation function takes in the current and proposed successor
        GameStates (pacman.py) and returns a number, where higher numbers are better.

        The code below extracts some useful information from the state, like the
        remaining food (newFood) and Pacman position after moving (newPos).
        newScaredTimes holds the number of moves that each ghost will remain
        scared because of Pacman having eaten a power pellet.

        Print out these variables to see what you're getting, then combine them
        to create a masterful evaluation function.
        """
        # Useful information you can extract from a GameState (pacman.py)
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        newPos = successorGameState.getPacmanPosition()
        newFood = successorGameState.getFood()
        newGhostStates = successorGameState.getGhostStates()
        newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]

        "*** YOUR CODE HERE ***"
        return successorGameState.getScore()

def scoreEvaluationFunction(currentGameState: GameState):
    """
    This default evaluation function just returns the score of the state.
    The score is the same one displayed in the Pacman GUI.

    This evaluation function is meant for use with adversarial search agents
    (not reflex agents).
    """
    return currentGameState.getScore()

class MultiAgentSearchAgent(Agent):
    """
    This class provides some common elements to all of your
    multi-agent searchers.  Any methods defined here will be available
    to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

    You *do not* need to make any changes here, but you can if you want to
    add functionality to all your adversarial search agents.  Please do not
    remove anything, however.

    Note: this is an abstract class: one that should not be instantiated.  It's
    only partially specified, and designed to be extended.  Agent (game.py)
    is another abstract class.
    """

    def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
        self.index = 0 # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)


#
#CITE THIS SOURCE BEFORE SUBMITTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#Note: yes, it uses pseudocode, not C#
#Q2,3, maybe 4
#
#great reference: https://www.youtube.com/watch?v=l-hh51ncgDI

class MinimaxAgent(MultiAgentSearchAgent):
    """
    Your minimax agent (question 2)
    """

    def getAction(self, gameState: GameState):
        """
        Returns the minimax action from the current gameState using self.depth
        and self.evaluationFunction.

        Here are some method calls that might be useful when implementing minimax.

        gameState.getLegalActions(agentIndex):
        Returns a list of legal actions for an agent
        agentIndex=0 means Pacman, ghosts are >= 1

        gameState.generateSuccessor(agentIndex, action):
        Returns the successor game state after an agent takes an action

        gameState.getNumAgents():
        Returns the total number of agents in the game

        gameState.isWin():
        Returns whether or not the game state is a winning state

        gameState.isLose():
        Returns whether or not the game state is a losing state
        """
        
        bestAction = None
        maxScore = float('-inf')
        legalActions = gameState.getLegalActions(0)

        for action in legalActions:
            successor = gameState.generateSuccessor(0, action)
            score = self.minimax(1, 0, successor)
            if score > maxScore:
                maxScore = score
                bestAction = action
        return bestAction
    
    def minimax(self, agentIndex, depth, state):

        if state.isWin() or state.isLose() or depth == self.depth:
            return self.evaluationFunction(state)
        
        numAgents = state.getNumAgents()

        if agentIndex == 0:
            maxScore = float('-inf')
            for action in state.getLegalActions(agentIndex):
                successor = state.generateSuccessor(agentIndex, action)
                score = self.minimax(1, depth, successor) #
                maxScore = max(maxScore, score)
            return maxScore
        
        else:
            minScore = float('inf')
            for action in state.getLegalActions(agentIndex):
                successor = state.generateSuccessor(agentIndex, action)
                nextAgent = agentIndex + 1
                nextDepth = depth
                if nextAgent == numAgents:
                    nextAgent = 0
                    nextDepth += 1
                score = self.minimax(nextAgent, nextDepth, successor)
                minScore = min(minScore, score)
            return minScore
    
class AlphaBetaAgent(MultiAgentSearchAgent):
    """
    Your minimax agent with alpha-beta pruning (question 3)
    """

    def getAction(self, gameState: GameState):
        """
        Returns the minimax action using self.depth and self.evaluationFunction
        """
        
        bestAction = None
        maxScore = float('-inf')
        alpha = float('-inf')
        beta = float('inf')
        legalActions = gameState.getLegalActions(0)

        for action in legalActions:
            successor = gameState.generateSuccessor(0, action)
            score = self.alphaBeta(1, 0, successor, alpha, beta)
            if score > maxScore:
                maxScore = score
                bestAction = action
            alpha = max(alpha, score) #Alpha value of depth 1's highest pacman score

        return bestAction
    
    def alphaBeta(self, agentIndex, depth, state, alpha, beta):

        if state.isWin() or state.isLose() or depth == self.depth:
            return self.evaluationFunction(state)
        
        numAgents = state.getNumAgents()
        
        if agentIndex == 0:
            maxScore = float('-inf')
            for action in state.getLegalActions(agentIndex):
                successor = state.generateSuccessor(agentIndex, action)
                score = self.alphaBeta(1, depth, successor, alpha, beta)
                maxScore = max(maxScore, score)
                alpha = max(alpha, score)
                if alpha > beta:
                    break
            return maxScore
        
        else:
            minScore = float('inf')
            for action in state.getLegalActions(agentIndex):
                successor = state.generateSuccessor(agentIndex, action)
                nextAgent = agentIndex + 1
                nextDepth = depth
                if nextAgent == numAgents:
                    nextAgent = 0
                    nextDepth += 1
                score = self.alphaBeta(nextAgent, nextDepth, successor, alpha, beta)
                minScore = min(minScore, score)
                beta = min(beta, score)
                if beta < alpha:
                    break
            return minScore


class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """

    def getAction(self, gameState: GameState):
        """
        Returns the expectimax action using self.depth and self.evaluationFunction

        All ghosts should be modeled as choosing uniformly at random from their
        legal moves.
        """
        bestAction = None
        maxScore = float('-inf')
        legalActions = gameState.getLegalActions(0)

        for action in legalActions:
            successor = gameState.generateSuccessor(0, action)
            score = self.expectimax(1, 0, successor)
            if score > maxScore:
                maxScore = score
                bestAction = action
        return bestAction
    
    def expectimax(self, agentIndex, depth, state):

        if state.isWin() or state.isLose() or depth == self.depth:
            return self.evaluationFunction(state)
        
        numAgents = state.getNumAgents()

        if agentIndex == 0:
            maxScore = float('-inf')
            for action in state.getLegalActions(agentIndex):
                successor = state.generateSuccessor(agentIndex, action)
                score = self.expectimax(1, depth, successor)
                maxScore = max(maxScore, score)
            return maxScore
        
        else:
            totalScore = 0
            legalActions = state.getLegalActions(agentIndex)
            numActions = len(legalActions)
            if numActions == 0: #No possible moves for ghost to take i.e. stuck in corner
                return self.evaluationFunction(state)
            for action in legalActions:
                successor = state.generateSuccessor(agentIndex, action)
                nextAgent = agentIndex + 1
                nextDepth = depth
                if nextAgent == numAgents:
                    nextAgent = 0
                    nextDepth += 1
                score = self.expectimax(nextAgent, nextDepth, successor)
                totalScore += score
            return totalScore / numActions #represents the average random score for the possible moves from the ghosts. Here, each move is equally as likely.


def betterEvaluationFunction(currentGameState: GameState):
    """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).

    DESCRIPTION: <write something here so we know what you did>
    """
def betterEvaluationFunction(currentGameState: GameState):
    """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).
    """
    # Get useful information from the current state
    pacmanPos = currentGameState.getPacmanPosition()
    foodGrid = currentGameState.getFood()
    ghostStates = currentGameState.getGhostStates()
    capsules = currentGameState.getCapsules()
    score = currentGameState.getScore()

    # Feature 1: Distance to the closest food
    foodDistances = [manhattanDistance(pacmanPos, foodPos) for foodPos in foodGrid.asList()]
    closestFoodDistance = min(foodDistances) if foodDistances else 1  # Avoid division by zero

    # Feature 2: Ghost Danger
    ghostDanger = 0
    for ghostState in ghostStates:
        ghostPos = ghostState.getPosition()
        distanceToGhost = manhattanDistance(pacmanPos, ghostPos)
        
        if distanceToGhost == 0:
            ghostDanger += 1000  # Large penalty for being on the same position as an active ghost
        elif ghostState.scaredTimer == 0 and distanceToGhost < 3:
            ghostDanger += 10 / distanceToGhost  # Higher penalty for being close to an active ghost
        elif ghostState.scaredTimer > 0:
            ghostDanger -= 200 / distanceToGhost  # Reward for getting close to scared ghosts

    # Feature 3: Distance to Capsules
    capsuleDistances = [manhattanDistance(pacmanPos, capPos) for capPos in capsules]
    closestCapsuleDistance = min(capsuleDistances) if capsuleDistances else 1  # Avoid division by zero

    # Combine the features into an evaluation value
    evaluation = (
        score
        + 10.0 / closestFoodDistance  # Incentivize Pacman to move towards food
        - ghostDanger  # Penalize being near active ghosts
        + 50.0 / closestCapsuleDistance  # Incentivize capsules
    )

    return evaluation

# Abbreviation
better = betterEvaluationFunction