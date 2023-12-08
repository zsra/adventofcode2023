package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	file, err := os.Open("day8.in")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	var input []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		input = append(input, scanner.Text())
	}

	instructions := make([]int, len(input[0]))
	for i, char := range input[0] {
		if char == 'L' {
			instructions[i] = 0
		} else {
			instructions[i] = 1
		}
	}

	nodes := make(map[string][]string)
	for _, line := range input[2:] {
		parts := strings.FieldsFunc(line, func(r rune) bool {
			return r == ' ' || r == ',' || r == '(' || r == ')' || r == '='
		})
		nodes[parts[0]] = parts[1:]
	}

	var result1, result2 int64

	for node := "AAA"; node != "ZZZ"; result1++ {
		node = nodes[node][instructions[result1%int64(len(instructions))]]
	}

	findLoopFrequency := func(node string) (int64, int64) {
		endSeen := make(map[string]int64)
		for i := int64(0); ; i++ {
			if node[2] == 'Z' {
				if lastSeen, exists := endSeen[node]; exists {
					return lastSeen, i - lastSeen
				} else {
					endSeen[node] = i
				}
			}
			node = nodes[node][instructions[i%int64(len(instructions))]]
		}
	}

	var frequencies []struct{ phase, period int64 }
	for key := range nodes {
		if key[2] == 'A' {
			phase, period := findLoopFrequency(key)
			frequencies = append(frequencies, struct{ phase, period int64 }{phase, period})
		}
	}

	harmonyPhase, harmonyPeriod := frequencies[0].phase, frequencies[0].period
	for _, freq := range frequencies[1:] {
		for ; harmonyPhase < freq.phase || (harmonyPhase-freq.phase)%freq.period != 0; harmonyPhase += harmonyPeriod {
		}

		sample := harmonyPhase + harmonyPeriod
		for ; (sample-freq.phase)%freq.period != 0; sample += harmonyPeriod {
		}
		harmonyPeriod = sample - harmonyPhase
	}
	result2 = harmonyPhase

	fmt.Printf("Result1 = %d\n", result1)
	fmt.Printf("Result2 = %d\n", result2)
}
