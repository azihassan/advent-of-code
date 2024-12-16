import std;

void main()
{
    char[][] grid;
    foreach(line; stdin.byLine.map!strip)
    {
        if(line == "")
        {
            break;
        }
        grid ~= line.dup;
    }

    string moves = readln().strip();
    foreach(line; stdin.byLine.map!strip)
    {
        moves ~= line;
    }
    grid.simulate(moves).calculateBoxCoordinateSums().writeln();
}

ulong calculateBoxCoordinateSums(char[][] grid)
{
    ulong sum;
    foreach(y, row; grid)
    {
        foreach(x, cell; row)
        {
            if(cell == 'O')
            {
                sum += 100 * y + x;
            }
        }
    }
    return sum;
}

void draw(char[][] grid, char move)
{
    writeln("Move ", move, ":");
    grid.each!writeln();
    writeln();
}

char[][] simulate(char[][] grid, string moves)
{
    Point start = grid.findRobot();
    Point[dchar] directions = [
        '>': Point(+1, 0),
        '<': Point(-1, 0),
        'v': Point(0, +1),
        '^': Point(0, -1),
    ];
    assert(start != Point(-1, -1));
    return grid.simulate(moves.map!(move => directions[move.to!dchar]).array, start);
}

char[][] simulate(char[][] grid, Point[] moves, Point robot)
{
    foreach(move; moves)
    {
        Point next = robot + move;
        if(grid.cellAt(next) == '.')
        {
            grid[robot.y][robot.x] = '.';
            grid[next.y][next.x] = '@';
            robot = next;
        }
        else if(grid.cellAt(next) == 'O')
        {
            robot = grid.pushCrates(robot, move);
        }
    }
    return grid;
}

Point pushCrates(char[][] grid, Point robot, Point move)
{
    Point next = robot + move;
    Point crate = next;
    while(grid.cellAt(crate) != '.' && grid.cellAt(crate) != '#')
    {
        crate = crate + move;
    }
    if(grid.cellAt(crate) == '.')
    {
        char tmp = grid.cellAt(crate);
        grid[crate.y][crate.x] = grid.cellAt(next);
        grid[next.y][next.x] = tmp;

        grid[robot.y][robot.x] = '.';
        grid[next.y][next.x] = '@';
        robot = next;
    }
    return robot;
}

char cellAt(char[][] grid, Point p)
{
    return grid[p.y][p.x];
}

Point findRobot(char[][] grid)
{
    foreach(y, row; grid)
    {
        foreach(x, cell; row)
        {
            if(cell == '@')
            {
                return Point(cast(int) x, cast(int) y);
            }
        }
    }
    return Point(-1, -1);
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
        else if(operator == "*")
        {
            return Point(x * other.x, y * other.y);
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
