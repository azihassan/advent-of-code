import std;

void main()
{
    long tokenTotal;
    Point a, b, prize;
    foreach(line; stdin.byLine.map!strip)
    {
        if(line == "")
        {
            long[] tokens = prize.findSmallestNumberOfPresses(a, b);
            tokenTotal += tokens[0] * 3 + tokens[1];
            a = Point(0, 0);
            b = Point(0, 0);
            prize = Point(0, 0);
        }
        else if(line.startsWith("Button A"))
        {
            line.formattedRead!"Button A: X%d, Y%d"(a.x, a.y);
        }
        else if(line.startsWith("Button B"))
        {
            line.formattedRead!"Button B: X%d, Y%d"(b.x, b.y);
        }
        else if(line.startsWith("Prize"))
        {
            line.formattedRead!"Prize: X=%d, Y=%d"(prize.x, prize.y);
            prize.x += 10000000000000L;
            prize.y += 10000000000000L;
        }
    }
    writeln(tokenTotal);
}

long[] findSmallestNumberOfPresses(Point p, Point a, Point b)
{
    long N = (p.x * a.y - p.y * a.x) / (a.y * b.x - a.x * b.y);
    long M = (p.y - N * b.y) / a.y;

    if(M * a.x + N * b.x == p.x && M * a.y + N * b.y == p.y)
    {
        return [M, N];
    }
    return [0, 0];
}

struct Point
{
    long x;
    long y;

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
