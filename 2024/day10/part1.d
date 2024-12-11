import std;

void main()
{
    char[][] grid = stdin.byLine.map!strip.map!dup.array();
    int scoreSum;
    foreach(trailhead, nines; grid.findNines())
    {
        scoreSum += nines.length;
    }
    writeln("Sum: ", scoreSum);
}

Point[][Point] findNines(char[][] grid)
{
    Point[][Point] trailHeads;
    foreach(y; 0 .. grid.length)
    {
        foreach(x; 0 .. grid[0].length)
        {
            if(grid[y][x] == '0')
            {
                Point start = Point(cast(int) x, cast(int) y);
                trailHeads[start] ~= grid.findNines(start).keys();
            }
        }
    }
    return trailHeads;
}

bool[Point] findNines(char[][] grid, Point start)
{
    bool[Point] visited;
    return grid.findNines(start, visited);
}

bool[Point] findNines(char[][] grid, Point start, bool[Point] visited)
{
    bool[Point] nines;
    visited[start] = true;
    if(grid[start.y][start.x] == '9')
    {
        nines[start] = true;
        return nines;
    }

    foreach(neighbor; start.neighbors())
    {
        if(grid.isWithinBounds(neighbor) && grid[neighbor.y][neighbor.x] - '0' == (grid[start.y][start.x] - '0') + 1 && neighbor !in visited)
        {
            nines = nines.merge(grid.findNines(neighbor, visited));
        }
    }
    return nines;
}

Point[] neighbors(Point p)
{
    return [
        Point(p.x - 1, p.y),
        Point(p.x + 1, p.y),
        Point(p.x, p.y - 1),
        Point(p.x, p.y + 1)
    ];
}

bool isWithinBounds(char[][] grid, Point p)
{
    return 0 <= p.y && p.y < grid.length && 0 <= p.x && p.x < grid[0].length;
}

bool[Point] merge(bool[Point] a, bool[Point] b)
{
    bool[Point] merged;
    foreach(key, value; a)
    {
        merged[key] = value;
    }
    foreach(key, value; b)
    {
        merged[key] = value;
    }
    return merged;
}

struct Point
{
    int x;
    int y;

    Point distance(Point other)
    {
        return Point(other.x - x, other.y - y);
    }

    Point opBinary(string operator)(Point other)
    {
        static if(operator == "+")
        {
            return Point(x + other.x, y + other.y);
        }
        else if(operator == "-")
        {
            return Point(x - other.x, y - other.y);
        }
        assert(false);
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

unittest
{
    assert(Point(1, 2) + Point(-1, -2) == Point(0, 0));
    assert(Point(1, 2) - Point(-1, -2) == Point(1, 2) + Point(1, 2));
    assert(Point(1, 2) == Point(1, 2));
    assert(Point(2, 1) != Point(1, 2));
    assert(Point(2, 1).toString() == "[2, 1]");
    assert(Point(1, 2).distance(Point(3, 3)) == Point(2, 1));
    assert(Point(4, 2).distance(Point(4, 2)) == Point(0, 0));
}
