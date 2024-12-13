package main

import (
    "fmt"
    "log"
    "io/ioutil"
    "strings"
)

type Point struct {
    x, y int
}

type Map struct {
    antennas map[rune][]Point
    lines    []string
    x        int
    y        int
}

func NewMap(inputLines []string) *Map {
    return &Map{ antennas: make(map[rune][]Point), lines: inputLines }
}

func (m *Map) Init() {
    m.antennas = make(map[rune][]Point)
    m.x = len(m.lines[0])
    m.y = len(m.lines)

    for y, line := range m.lines {
        for x, char := range line {
            if char != '.' {
                m.antennas[char] = append(m.antennas[char], Point{x,y})
            }
        }
    }
}

func (m *Map) CountAntinodes(infinite bool) int {
    antinodes := make(map[Point]struct{})

    for _, pos := range m.antennas {
        for i := 0; i < len(pos); i++ {
            for k := i + 1; k < len(pos); k++ {
                dX := pos[i].x - pos[k].x
                dY := pos[i].y - pos[k].y
                t := 0
                added := true
                offset := 1 // Start at 1 if not infinite
                if infinite {
                    offset = 0
                }

                for added {
                    a1 := m.AddAntinode(antinodes, Point{
                        x: pos[i].x + dX*(t+offset),
                        y: pos[i].y + dY*(t+offset),
                    })
                    a2 := m.AddAntinode(antinodes, Point{
                        x: pos[k].x - dX*(t+offset),
                        y: pos[k].y - dY*(t+offset),
                    })
                    added = infinite && (a1 || a2)
                    t++
                }
            }
        }
    }

    return len(antinodes)
}

func (m *Map) AddAntinode(hashSet map[Point]struct{}, point Point) bool {
    canAdd := point.x >= 0 && point.y >= 0 && point.x < m.x && point.y < m.y
    if canAdd {
        hashSet[point] = struct{}{}
    }
    return canAdd
}

func main() {
    // Read the input from the file
    data, err := ioutil.ReadFile("input.txt")
    if err != nil {
        log.Fatalf("Failed to read input file: %v", err)
    }

    // Split the input into lines
    lines := strings.Split(strings.TrimSpace(string(data)), "\n")

    // Initialize the Map with the input lines
    antennas := NewMap(lines)
    antennas.Init()

    infinite := false
    fmt.Printf("Antinodes 1st order: %d\n", antennas.CountAntinodes(infinite))
    infinite = true
    fmt.Printf("Antinodes nth order: %d\n", antennas.CountAntinodes(infinite))
}
