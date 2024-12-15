import std;

enum WIDTH = 101;
enum HEIGHT = 103;
void main()
{
    Robot[] robots;
    foreach(line; stdin.byLine)
    {
        Robot r;
        line.formattedRead!"p=%d,%d v=%d,%d"(r.position.x, r.position.y, r.velocity.x, r.velocity.y);
        robots ~= r;
    }
    foreach(i; iota(74, 10000, 101))
    {
        writeln("Iteration #", i);
        int[][] grid = 0.repeat.take(WIDTH).array.repeat.take(HEIGHT).map!dup.array;
        grid = grid.simulate(robots, i);
        grid.draw();
        writeln();
        writeln();
        writeln();
    }
}

void draw(int[][] grid)
{
    foreach(row; grid)
    {
        row.map!(n => n == 0 ? " " : "#").joiner().writeln();
    }
}

int[][] simulate(int[][] grid, Robot[] robots, int iterations)
{
    foreach(robot; robots)
    {
        robot.position = (robot.position + (robot.velocity * Point(iterations, iterations))) % Point(cast(int)(grid[0].length), cast(int)(grid.length));
        int y = modulo(robot.position.y, cast(int)(grid.length));
        int x = modulo(robot.position.x, cast(int)(grid[0].length));

        grid[y][x]++;
    }
    return grid;
}

int modulo(int a, int b)
{
    return a >= 0 ? a % b : ( b - abs ( a%b ) ) % b;
}

int[4] countByQuadrant(int[][] grid)
{
    int[4] result = [0, 0, 0, 0];
    foreach(y, row; grid)
    {
        foreach(x, count; row)
        {
            if(y == grid.length / 2 || x == grid[0].length / 2)
            {
                continue;
            }
            if(0 <= x && x < grid[0].length / 2 && 0 <= y && y < grid.length / 2)
            {
                result[0] += count;
            }
            else if(grid[0].length / 2 < x && x < grid[0].length && 0 <= y && y < grid.length / 2)
            {
                result[1] += count;
            }
            else if(0 <= x && x < grid[0].length / 2 && grid.length / 2 < y && y < grid.length)
            {
                result[2] += count;
            }
            else
            {
                result[3] += count;
            }
        }
    }
    return result;
}

struct Robot
{
    Point position;
    Point velocity;
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
        else if(operator == "%")
        {
            return Point(x.modulo(other.x), y.modulo(other.y));
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
