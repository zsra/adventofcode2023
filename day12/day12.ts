import * as fs from 'fs';

const input: string[] = fs.readFileSync('day12.in', 'utf-8').split('\n').filter(Boolean);

let part1: number = 0;
let part2: number = 0;
const cache: Map<string, number> = new Map();

for (const line of input.map(l => l.split(' '))) {
    const springs: string = line[0];
    const groups: number[] = line[1].split(',').map(Number);

    part1 += calculate(springs, groups);

    const repeatedSprings: string = Array(5).fill(springs).join('?');
    const repeatedGroups: number[] = Array(5).fill(groups).flatMap(g => g);

    part2 += calculate(repeatedSprings, repeatedGroups);
}

console.log(`Part1: ${part1}`);
console.log(`Part2: ${part2}`);
process.exit();

function calculate(springs: string, groups: number[]): number {
    const key: string = `${springs},${groups.join(',')}`;

    if (cache.has(key)) {
        return cache.get(key)!;
    }

    const value: number = getCount(springs, groups);
    cache.set(key, value);

    return value;
}

function getCount(springs: string, groups: number[]): number {
    while (true) {
        if (groups.length === 0) {
            return springs.includes('#') ? 0 : 1;
        }

        if (!springs.length) {
            return 0;
        }

        if (springs.startsWith('.')) {
            springs = springs.replace(/^\.+/, '');
            continue;
        }

        if (springs.startsWith('?')) {
            const option1 = calculate('.' + springs.substring(1), groups);
            const option2 = calculate('#' + springs.substring(1), groups);
            return option1 + option2;
        }

        if (springs.startsWith('#')) {
            if (groups.length === 0) {
                return 0;
            }

            if (springs.length < groups[0]) {
                return 0;
            }

            if (springs.substring(0, groups[0]).includes('.')) {
                return 0;
            }

            if (groups.length > 1) {
                if (springs.length < groups[0] + 1 || springs[groups[0]] === '#') {
                    return 0;
                }

                springs = springs.substring(groups[0] + 1);
                groups = groups.slice(1);
                continue;
            }

            springs = springs.substring(groups[0]);
            groups = groups.slice(1);
            continue;
        }

        throw new Error("Invalid input");
    }
}
