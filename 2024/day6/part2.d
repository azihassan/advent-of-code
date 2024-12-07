import std;

immutable string DIRECTIONS = "^>v<";

void main()
{
    char[][] grid = stdin.byLine.map!dup.map!strip.array;
    Point[] candidates = grid.findDinstinctSteps().keys;
    grid.each!writeln;

    int loopCount;
    writeln("Bruteforcing thourgh ", candidates.length, " points");
    foreach(i, candidate; candidates)
    {
        if(grid[candidate.y][candidate.x] != '.')
        {
            continue;
        }
        grid[candidate.y][candidate.x] = '#';
        writeln(i, "/", candidates.length, ": ", candidate.x, ", ", candidate.y);
        if(grid.hasLoop())
        {
            loopCount++;
            writeln("Found loop at ", candidate.x, ", ", candidate.y);
        }
        grid[candidate.y][candidate.x] = '.';
    }
    loopCount.writeln();
}

bool hasLoop(char[][] grid)
{
    int[Point] distinctSteps;
    Point player = grid.findStart();
    Point originalPoint = player;
    assert(player != Point(-1, -1));
    char direction = grid[player.y][player.x];
    char originalDirection = direction;
    distinctSteps[player]++;
    while(true)
    {
        //arbitrary threshold because it's 2 AM
        if(distinctSteps.hasLoop(4))
        {
            return true;
        }
        Point next = grid.advance(direction, player);
        if(grid.isOutOfBounds(next))
        {
            break;
        }
        if(grid[next.y][next.x] == '#')
        {
            direction = direction.rotateRight();
            continue;
        }
        distinctSteps[next]++;
        player = next;

    }
    return false;
}

//duplicated code but it's 2 AM
bool[Point] findDinstinctSteps(char[][] grid)
{
    bool[Point] distinctSteps;
    Point player = grid.findStart();
    assert(player != Point(-1, -1));
    char direction = grid[player.y][player.x];
    while(true)
    {
        Point next = grid.advance(direction, player);
        if(grid.isOutOfBounds(next))
        {
            break;
        }
        if(grid[next.y][next.x] == '#')
        {
            direction = direction.rotateRight();
            continue;
        }
        distinctSteps[next] = true;
        player = next;
    }
    return distinctSteps;
}

struct Point
{
    int x;
    int y;

    Point opBinary(string operator)(Point other) if(operator == "+")
    {
        return Point(x + other.x, y + other.y);
    }

    bool opEquals()(auto ref const Point other) const
    {
        return x == other.x && y == other.y;
    }

    size_t toHash() const
    {
        return toString().hashOf;
    }

    string toString() const
    {
        return format!"[%d, %d]"(x, y);
    }
}

bool hasLoop(int[Point] distinctSteps, ulong threshold)
{
    //writeln(distinctSteps);
    return distinctSteps.length > 0 && distinctSteps.byValue.any!(step => step > threshold);
}

Point advance(char[][] grid, char direction, Point point)
{
    Point[char] deltas = [
        '^': Point(0, -1),
        '>': Point(1, 0),
        'v': Point(0, 1),
        '<': Point(-1, 0)
    ];
    return point + deltas[direction];
}

bool isOutOfBounds(char[][] grid, Point point)
{
    return !(0 <= point.x && point.x < grid[0].length && 0 <= point.y && point.y < grid.length);
}

char rotateRight(char current)
{
    return DIRECTIONS[(DIRECTIONS.indexOf(current) + 1) % $];
}

Point findStart(char[][] grid)
{
    foreach(y; 0 .. grid.length)
    {
        foreach(x; 0 .. grid[y].length)
        {
            char current = grid[y][x];
            if(current == '^' || current == '>' || current == 'v' || current == '<')
            {
                return Point(cast(int) x, cast(int) y);
            }
        }
    }
    return Point(-1, -1);
}
