import std;

void main()
{
    char[][] grid = stdin.byLine.map!strip.map!dup.array();
    grid.findAntinodes().length.writeln();
}

void draw(char[][] grid)
{
    grid.each!writeln();
    writeln();
}

Point[] findAntinodes(char[][] grid)
{
    bool[Point] allAntinodes;
    Point[] antennas = grid.findAntennas();
    foreach(i, antenna; antennas)
    {
        foreach(j, twin; antennas[i + 1 .. $])
        {
            if(grid[antenna.y][antenna.x] != grid[twin.y][twin.x])
            {
                continue;
            }
            Point[] antinodes = grid.calculateAntinodes(antenna, twin);
            foreach(antinode; antinodes)
            {
                allAntinodes[antinode] = true;
                if(grid[antinode.y][antinode.x] != '.')
                {
                    continue;
                }
                grid[antinode.y][antinode.x] = '#';
            }
        }
    }
    grid.draw();
    return allAntinodes.keys();
}

Point[] findAntennas(char[][] grid)
{
    Point[] antennas;
    foreach(y; 0 .. grid.length)
    {
        foreach(x; 0 .. grid[0].length)
        {
            if(grid[y][x] != '.' && grid[y][x] != '#')
            {
                antennas ~= Point(cast(int) x, cast(int) y);
            }
        }
    }
    return antennas;
}

Point[] calculateAntinodes(char[][] grid, Point antenna, Point twin)
{
    Point[] antinodes = [antenna, twin];
    Point[] distances = [antenna.distance(twin), antenna.distance(twin)];
    while(true)
    {
        Point antinode = antenna - distances[0];
        if(!grid.isWithinBounds(antinode))
        {
            break;
        }
        antinodes ~= antinode;
        antenna = antinode;
    }

    while(true)
    {
        Point antinode = twin + distances[1];
        if(!grid.isWithinBounds(antinode))
        {
            break;
        }
        antinodes ~= antinode;
        twin = antinode;
    }
    return antinodes;
}

bool isWithinBounds(char[][] grid, Point p)
{
    return 0 <= p.y && p.y < grid.length && 0 <= p.x && p.x < grid[0].length;
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
