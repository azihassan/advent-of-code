import std;

immutable string DIRECTIONS = "^>v<";

void main()
{
    char[][] grid = stdin.byLine.map!dup.map!strip.array;
    grid.findDinstinctSteps().length.writeln();
}

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
