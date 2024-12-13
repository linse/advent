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
    id     int // Identifier for the block, -1 represents free space
    fileID int // Original file ID of the block
}

// parseDiskMap decompresses the disk map into a list of Block structs.
func parseDiskMap(diskMap string) []Block {
    var blocks []Block
    fileID := 0

    // Decompressing the disk map
    for i := 0; i < len(diskMap); i += 2 {
        fileLength := int(diskMap[i] - '0')
        // Add blocks for the current file
        for j := 0; j < fileLength; j++ {
            blocks = append(blocks, Block{id: fileID, fileID: fileID})
        }

        if i+1 < len(diskMap) {
            freeLength := int(diskMap[i+1] - '0')
            // Add free space blocks
            for j := 0; j < freeLength; j++ {
                blocks = append(blocks, Block{id: -1, fileID: -1}) // Free space is indicated by `id: -1`
            }
        }
        fileID++
    }

    return blocks
}

// moveFilesRightToLeft moves entire files from right to left into the earliest suitable free space.
func moveFilesRightToLeft(blocks []Block) {
    n := len(blocks)

    // Iterate through the blocks from right to left to identify files
    for i := n - 1; i >= 0; {
        if blocks[i].id == -1 {
            // Skip free space as we're going from right to left
            i--
            continue
        }

        // Identify the current file's start and end positions
        fileID := blocks[i].id
        fileEnd := i
        fileStart := i
        for fileStart >= 0 && blocks[fileStart].id == fileID {
            fileStart--
        }
        fileStart++ // Adjust to the first block of this file

        // File length
        fileLength := fileEnd - fileStart + 1

        // Find the earliest free span from the left
        for j := 0; j < fileStart; j++ {
            if isFreeSpaceAvailable(blocks, j, fileLength) {
                // Move the file to this free span
                for k := 0; k < fileLength; k++ {
                    blocks[j+k] = blocks[fileStart+k]
                    blocks[fileStart+k] = Block{id: -1, fileID: -1} // Mark the original as free
                }
                break
            }
        }

        // Move to the next file by setting i beyond the current file to continue the loop
        i = fileStart - 1
    }
}

// isFreeSpaceAvailable checks if a contiguous space is available to fit the entire file.
func isFreeSpaceAvailable(blocks []Block, start, length int) bool {
    for i := start; i < start+length; i++ {
        if i >= len(blocks) || blocks[i].id != -1 {
            return false
        }
    }
    return true
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

    // Perform defragmentation by file.
    moveFilesRightToLeft(blocks)

    // Print the final defragmented state.
    fmt.Println("Final state:")
    fmt.Println(blocksToString(blocks))

    // Calculate and print the checksum of the defragmented disk.
    checksum := calculateChecksum(blocks)
    fmt.Printf("Checksum: %d\n", checksum)
}
