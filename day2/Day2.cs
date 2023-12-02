namespace day2;

internal class Day2
{
    public int GetAnswer()
    {
        const int NUMBER_OF_RED = 12;
        const int NUMBER_OF_BLUE = 14;
        const int NUMBER_OF_GREEN = 13;

        int sum = 0;
        foreach (var parts in from line in File.ReadLines("day2.in")
                              let parts = line.Split(':', StringSplitOptions.RemoveEmptyEntries)
                              select parts)
        {
            if (int.TryParse(parts[0][5..], out int gameId))
            {
                var cubeSets = parts[1].Split(';', StringSplitOptions.RemoveEmptyEntries);

                bool isGameValid = cubeSets.All(cubes =>
                {
                    var cubeValues = cubes.Split(",", StringSplitOptions.RemoveEmptyEntries);

                    return cubeValues.All(cubeValue =>
                    {
                        var trimmedParts = cubeValue.Trim().Split(' ', StringSplitOptions.RemoveEmptyEntries);

                        return trimmedParts[1] switch
                        {
                            "blue" => int.Parse(trimmedParts[0]) <= NUMBER_OF_BLUE,
                            "red" => int.Parse(trimmedParts[0]) <= NUMBER_OF_RED,
                            "green" => int.Parse(trimmedParts[0]) <= NUMBER_OF_GREEN,
                            _ => false,
                        };
                    });
                });

                if (isGameValid)
                {
                    sum += gameId;
                }
            }
        }

        return sum;
    }
}
