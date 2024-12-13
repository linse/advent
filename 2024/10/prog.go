package main

import (
    "fmt"
    "strings"
    "io/ioutil"
    "log"
)

// a coordinate on the map.
type Position struct {
    x, y int
}

// possible movements (left, right, up, down).
var directions = []Position{
    {-1, 0}, // up
    {1, 0},  // down
    {0, -1}, // left
    {0, 1},  // right
}

// parse a map string to a 2D grid of integers.
func makeGrid(mapString string) ([][]int, int, int) {
    lines := strings.Split(strings.TrimSpace(mapString), "\n")
    rows := len(lines)
    cols := len(strings.TrimSpace(lines[0]))

    grid := make([][]int, rows)
    for i, line := range lines {
        grid[i] = make([]int, cols)
        for j, ch := range strings.TrimSpace(line) {
            grid[i][j] = int(ch - '0')
        }
    }
    return grid, rows, cols
}

// find valid paths from all trailheads.
func findPaths(mapString string) map[Position][][]Position {
    grid, rows, cols := makeGrid(mapString)

    trailheadPaths := make(map[Position][][]Position)

    // Search for trailheads (0s) and start DFS from each.
    for i := 0; i < rows; i++ {
        for j := 0; j < cols; j++ {
            if grid[i][j] == 0 {
                position := Position{i, j}
                paths := [][]Position{}
                dfs(grid, position, 1, []Position{position}, &paths)
                trailheadPaths[position] = paths
            }
        }
    }
    return trailheadPaths
}

// dfs performs a depth-first search to collect valid paths from a position.
func dfs(grid [][]int, pos Position, seek int, path []Position, paths *[][]Position) {
    if seek > 9 {
        // if complete, add current path to the list.
        copiedPath := make([]Position, len(path))
        copy(copiedPath, path)
        *paths = append(*paths, copiedPath)
        return
    }

    rows := len(grid)
    cols := len(grid[0])

    // Explore all eight possible directions.
    for _, dir := range directions {
        newX, newY := pos.x+dir.x, pos.y+dir.y

        // Check if the new position is within bounds and is the next sequential number.
        if newX >= 0 && newX < rows && newY >= 0 && newY < cols && grid[newX][newY] == seek {
            // Append the new position to the current path and recurse.
            newPath := append(path, Position{newX, newY})
            dfs(grid, Position{newX, newY}, seek+1, newPath, paths)
        }
    }
}

// convert a path to a string, including coordinates and the char at the map position.
func pathToString(grid [][]int, path []Position) string {
    var sb strings.Builder

    for _, pos := range path {
        // format each position as: "(1, 2): 3"
        sb.WriteString(fmt.Sprintf("(%d, %d): %d, ", pos.x, pos.y, grid[pos.x][pos.y]))
    }
    sb.WriteString("\n")
    return sb.String()
}

// find the unique list of last positions from a list of paths.
func uniqueLastPositions(paths [][]Position) []Position {
    unique := make(map[Position]struct{})
    for _, path := range paths {
        if len(path) > 0 {
            lastPos := path[len(path)-1]
            unique[lastPos] = struct{}{}
        }
    }
    // Convert the map keys to a slice.
    var uniquePositions []Position
    for pos := range unique {
        uniquePositions = append(uniquePositions, pos)
    }
    return uniquePositions
}

func main() {
    // read topographic map from file
    data, err := ioutil.ReadFile("input.txt")
    if err != nil {
        log.Fatalf("Failed to read file: %v", err)
    }

    allPaths := findPaths(string(data))

    sum1 := 0
    sum2 := 0
    for _, trailheadPaths := range allPaths {
        sum1 += len(uniqueLastPositions(trailheadPaths))
        sum2 += len(trailheadPaths)
    }
    fmt.Printf("Score sum 1 %d!\n", sum1)
    fmt.Printf("Score sum 2 %d!\n", sum2)
}
