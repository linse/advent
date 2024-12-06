package main

import (
    "bufio"
    "errors"
    "fmt"
    "log"
    "os"
    "strings"
)

// A coordinate on the grid
type Point struct {
    x, y int
}

// Directions for movement: N, E, S, W
var directions = []Point{{-1, 0}, {0, 1}, {1, 0}, {0, -1}}

type Map struct {
    grid [][]rune
    guardInit Point
}

func NewMap(data []string) *Map {
    grid := make([][]rune, len(data))
    var guardPos Point

    for i, line := range data {
        grid[i] = []rune(line)
        if pos := strings.IndexRune(line, '^'); pos != -1 {
            guardPos = Point{i, pos}
        }
    }
    return &Map{grid: grid, guardInit: guardPos}
}

func (pm *Map) UniquePositions() map[Point]bool {
    visited, err := pm.walkUntilExit()
    if err != nil {
        log.Fatal(err)
    }

    uniquePositions := make(map[Point]bool)
    for pos := range visited {
        uniquePositions[pos.position] = true
    }
    return uniquePositions
}

type GuardState struct {
    position Point
    direction Point
}

var LoopError = errors.New("guard entered an endless loop")

func (pm *Map) walkUntilExit() (map[GuardState]bool, error) {
    guard := pm.guardInit
    visited := make(map[GuardState]bool)
    directionIndex := 0
    visited[GuardState{guard, directions[directionIndex]}] = true

    for {
        nextPos := Point{guard.x + directions[directionIndex].x, guard.y + directions[directionIndex].y}

        // Guard exited the grid
        if !pm.isInBounds(nextPos) {
            return visited, nil
        }
        // Tile ahead is blocked. Turn 90 degrees clockwise.
        if pm.grid[nextPos.x][nextPos.y] == '#' {
            directionIndex = (directionIndex + 1) % len(directions)
            continue
        }
        // Tile ahead is empty
        currentState := GuardState{nextPos, directions[directionIndex]}
        if visited[currentState] {
            // Guard is in loop, will never exit map
            return nil, LoopError
        }
        
        // Mark new position and direction as visited; update guard's position
        visited[currentState] = true
        guard = nextPos
    }
}

func (pm *Map) isInBounds(pos Point) bool {
    return pos.x >= 0 && pos.x < len(pm.grid) && pos.y >= 0 && pos.y < len(pm.grid[0])
}

func main() {
    // Open file
    file, err := os.Open("input.txt")
    if err != nil {
        log.Fatalf("Failed to open file: %v", err)
    }
    defer file.Close()

    // Read file line by line
    var data []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        data = append(data, scanner.Text())
    }
    if err := scanner.Err(); err != nil {
        log.Fatalf("Error reading file: %v", err)
    }
    pm := NewMap(data)

    // Part 1: Number of unique positions visited
    uniquePositions := pm.UniquePositions()
    fmt.Printf("Unique positions visited: %d\n", len(uniquePositions))

    // Part 2: The number of distinct obstacles that causes the guard to enter an endless loop
    obstaclesCounter := 0
    for pos := range uniquePositions {
        // Skip the guard's starting position
        if pos == pm.guardInit {
            continue
        }
        originalChar := pm.grid[pos.x][pos.y]
        // Skip already blocked tiles
        if originalChar == '#' {
            continue
        }
        // Temporarily block this tile and check for loops
        pm.grid[pos.x][pos.y] = '#'
        _, err := pm.walkUntilExit()
        if err == LoopError {
            obstaclesCounter++
        }
        // Restore the original character
        pm.grid[pos.x][pos.y] = originalChar
    }
    fmt.Printf("Number of distinct obstacles causing a loop: %d\n", obstaclesCounter)
}
