import * as fs from "fs"


function parseNumbers(str) {
  return str
    .split(" ")
    .filter(x => x !== "")
    .map(x => parseInt(x));
}

function groupNumbers(numbers, grouping) {
  const groups = [];
  for (let i = 0; i < numbers.length / grouping; i++) {
    groups.push(numbers.slice(i * grouping, i * grouping + grouping));
  }
  return groups;
}

const fileContent = fs.readFileSync("day5.in", { encoding: "utf8" });
const formattedContent = fileContent
  .replaceAll(/\r\n(\d)/g, " $1")
  .split("\r\n")
  .filter(x => x !== "")
  .map(x => parseNumbers(x.split(":")[1]));

const seeds = formattedContent[0];
const almanac = formattedContent.slice(1).map(x => groupNumbers(x, 3));

function getSeedLocation(step) {
  for (const almanacEntry of almanac) {
    for (const [destination, source, length] of almanacEntry) {
      if (source <= step && source + length > step) {
        step = destination + step - source;
        break;
      }
    }
  }
  return step;
}

console.log("Part 1: ", Math.min(...seeds.map(x => getSeedLocation(x))));

const seedRanges = groupNumbers(seeds, 2);

function doWeHaveThatSeed(seed) {
  return seedRanges.some(([seedStart, length]) => seedStart <= seed && seedStart + length >= seed);
}

function getSeedGivenLocation(step) {
  for (const almanacEntry of almanac.slice().reverse()) {
    for (const [destination, source, length] of almanacEntry) {
      if (destination <= step && destination + length > step) {
        step = source + step - destination;
        break;
      }
    }
  }
  return step;
}

for (let i = 0; i < 1000000000; i++) {
  const seed = getSeedGivenLocation(i);

  if (doWeHaveThatSeed(seed)) {
    console.log("Part 2: ", i);
    break;
  }
}