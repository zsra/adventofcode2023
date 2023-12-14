import Data.Char qualified as Char
import Data.Either qualified
import Data.Function ((&))
import Data.List qualified as L
import Data.Map qualified as Map
import Data.Ord qualified as O
import Data.Set qualified as S
import Data.Text qualified
import Debug.Trace (trace)
import System.Environment (lookupEnv)
import System.IO ()

main :: IO ()
main = do
  input <- readFile "day14.in"
  let parsedInput = parse input
  print $ part1 parsedInput
  print $ part2 parsedInput

-- Part 2: Applying transformations iteratively
part2 :: [[Char]] -> Int
part2 initGrid = load nth
  where
    (start, cycleLen, _) = detectCycle initGrid 0 Map.empty
    targetCycles = 1_000_000_000
    howManyMore = start + mod (targetCycles - start) cycleLen
    nth = iterate fullTilt initGrid !! howManyMore

-- Parsing the input
parse :: String -> [String]
parse = lines

-- Detecting cycles in the transformations
detectCycle :: (Num a) => [[Char]] -> a -> Map.Map [[Char]] a -> (a, a, [[Char]])
detectCycle grid count known =
  case Map.lookup grid known of
    Just start -> (start, count - start, grid)
    Nothing -> detectCycle (fullTilt grid) (count + 1) (Map.insert grid count known)

-- Part 1: Applying transformations once
part1 :: [String] -> Int
part1 = load . tilt

-- Calculating the load based on the number of 'O's in each row
load :: [[Char]] -> Int
load grid =
  sum . zipWith (*) revLengths $ map (length . filter (== 'O')) grid
  where
    n = length $ head grid
    revLengths = reverse [0 .. n]

-- Tilt the grid in a specific direction
tilt :: [String] -> [String]
tilt grid = tiltDir grid 0

-- Apply transformations in all directions
fullTilt :: [[Char]] -> [[Char]]
fullTilt grid = foldl tiltDir grid [0 .. 3]

-- Tilt the rows in a specific direction
tiltDir :: (Eq a, Num a) => [[Char]] -> a -> [[Char]]
tiltDir grid dir
  | dir == 0 = L.transpose $ map (tiltRow True) $ L.transpose grid
  | dir == 1 = map (tiltRow True) grid
  | dir == 2 = L.transpose $ map (tiltRow False) $ L.transpose grid
  | dir == 3 = map (tiltRow False) grid

-- Tilt a single row in a specific direction
tiltRow :: Bool -> [Char] -> [Char]
tiltRow front row
  | front = go ([], [], []) row
  | otherwise = reverse (go ([], [], []) (reverse row))
  where
    go (frontAcc, pendingO, pendingP) [] = frontAcc ++ pendingO ++ pendingP
    go accum@(frontAcc, pendingO, pendingP) (r : rs) =
      case r of
        '.' -> go (frontAcc, pendingO, r : pendingP) rs
        'O' -> go (frontAcc, r : pendingO, pendingP) rs
        '#' -> go accum [] ++ '#' : go ([], [], []) rs
