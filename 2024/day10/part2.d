import std;

void main()
{
    char[][] grid = stdin.byLine.map!strip.map!dup.array();
    int scoreSum;
    foreach(trailhead, trails; grid.findDistinctTrails())
    {
        scoreSum += trails.length;
    }
    writeln("Sum: ", scoreSum);
}

alias Path = immutable Point[];

Path[][Point] findDistinctTrails(char[][] grid)
{
    Path[][Point] trailHeads;
    foreach(y; 0 .. grid.length)
    {
        foreach(x; 0 .. grid[0].length)
        {
            if(grid[y][x] == '0')
            {
                Point start = Point(cast(int) x, cast(int) y);
                trailHeads[start] ~= grid.findDistinctTrails(start).keys();
            }
        }
    }
    return trailHeads;
}

bool[Path] findDistinctTrails(char[][] grid, Point start)
{
    bool[Path] visited;
    return grid.findDistinctTrails([start], visited);
}

bool[Path] findDistinctTrails(char[][] grid, Path path, bool[Path] visited)
{
    Point start = path[$ - 1];
    bool[Path] trails;
    visited[path] = true;
    if(grid[start.y][start.x] == '9')
    {
        trails[path] = true;
        return trails;
    }

    foreach(neighbor; start.neighbors())
    {
        if(grid.isWithinBounds(neighbor) && grid[neighbor.y][neighbor.x] - '0' == (grid[start.y][start.x] - '0') + 1 && (path ~ neighbor) !in visited)
        {
            trails = trails.merge(grid.findDistinctTrails(path ~ neighbor, visited));
        }
    }
    return trails;
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

bool[Path] merge(bool[Path] a, bool[Path] b)
{
    bool[Path] merged;
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
