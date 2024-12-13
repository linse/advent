package main

import (
    "fmt"
    "io/ioutil"
    "strings"
)

// Function to read the compressed disk map from a file.
func readDiskMapFromFile(filename string) (string, error) {
    data, err := ioutil.ReadFile(filename)
    if err != nil {
        return "", err
    }
    return strings.TrimSpace(string(data)), nil
}

// Block represents a disk block with its original file ID.
type Block struct {
    id     int
    fileID int // original file ID of the block
}

// parseDiskMap decompresses the disk map into a list of Block structs.
func parseDiskMap(diskMap string) []Block {
    var blocks []Block
    fileID := 0

    // Decompressing the disk map
    for i := 0; i < len(diskMap); i += 2 {
        fileLength := int(diskMap[i] - '0')
        for j := 0; j < fileLength; j++ {
            blocks = append(blocks, Block{id: fileID, fileID: fileID})
        }

        if i+1 < len(diskMap) {
            freeLength := int(diskMap[i+1] - '0')
            for j := 0; j < freeLength; j++ {
                blocks = append(blocks, Block{id: -1, fileID: -1}) // Free space is indicated by a special ID
            }
        }
        fileID++
    }

    return blocks
}

// defragment moves blocks from the end of the disk to the leftmost free space, one at a time.
func defragment(blocks []Block) {
    n := len(blocks)

    // Repeat the process until no more blocks can be moved.
    for {
        moved := false

        // Scan the list from right to left to locate file blocks.
        for i := n - 1; i > 0; i-- {
            // If it's a file block, attempt to move it to the leftmost free space.
            if blocks[i].id != -1 {
                for j := 0; j < i; j++ {
                    // Find the leftmost free space.
                    if blocks[j].id == -1 {
                        // Swap the block with the leftmost free space.
                        blocks[j], blocks[i] = blocks[i], blocks[j]
                        moved = true
                        // Print the state after each move for demonstration (debugging purposes).
                        //fmt.Println(blocksToString(blocks))
                        break // Exit the inner loop once a move is made.
                    }
                }
            }
        }

        // If no blocks were moved in the last pass, the disk is fully compacted.
        if !moved {
            break
        }
    }
}

// blocksToString converts the current state of blocks to a string representation for easy visualization.
func blocksToString(blocks []Block) string {
    var result strings.Builder
    for _, block := range blocks {
        if block.id == -1 {
            result.WriteRune('.')
        } else {
            result.WriteRune(rune('0' + block.id))
        }
    }
    return result.String()
}

func main() {
    // Read the disk map from the input file
    diskMap, err := readDiskMapFromFile("input.txt")
    if err != nil {
        fmt.Println("Error reading disk map:", err)
        return
    }

    // Parse the disk map into blocks.
    blocks := parseDiskMap(diskMap)

    // Print the initial state for debugging.
    fmt.Println("Initial state:")
    fmt.Println(blocksToString(blocks))

    // Perform defragmentation.
    defragment(blocks)

    // Print the final defragmented state.
    fmt.Println("Final state:")
    fmt.Println(blocksToString(blocks))

    // Calculate and print the checksum of the defragmented disk.
    checksum := calculateChecksum(blocks)
    fmt.Printf("Checksum: %d\n", checksum)
}

// calculateChecksum computes the checksum of the defragmented blocks.
func calculateChecksum(blocks []Block) int {
    checksum := 0
    for position, block := range blocks {
        if block.fileID != -1 {
            // Add the position multiplied by the original file ID.
            checksum += position * block.fileID
        }
    }
    return checksum
}
