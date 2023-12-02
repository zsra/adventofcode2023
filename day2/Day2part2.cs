namespace day2;

internal class Day2part2
{
    public int GetAnswer()
    {
        int sum = 0;
        foreach (var parts in from line in File.ReadLines("day2.in")
                              let parts = line.Split(':', StringSplitOptions.RemoveEmptyEntries)
                              select parts)
        {
            if (int.TryParse(parts[0][5..], out int gameId))
            {
                var cubeSets = parts[1].Split(';', StringSplitOptions.RemoveEmptyEntries);

                int maxRed = 0;
                int maxGreen = 0;
                int maxBlue = 0;

                foreach (var trimmedParts in from cubes in cubeSets
                                             let cubeValues = cubes.Split(",", StringSplitOptions.RemoveEmptyEntries)
                                             from cubeValue in cubeValues
                                             let trimmedParts = cubeValue.Trim().Split(' ', StringSplitOptions.RemoveEmptyEntries)
                                             select trimmedParts)
                {
                    int value = int.Parse(trimmedParts[0]);
                    switch (trimmedParts[1])
                    {
                        case "blue" when value > maxBlue:
                            maxBlue = value;
                            break;
                        case "red" when value > maxRed:
                            maxRed = value;
                            break;
                        case "green" when value > maxGreen:
                            maxGreen = value;
                            break;
                    }
                }

                sum += maxRed * maxGreen * maxBlue;
            }
        }

        return sum;
    }
}
