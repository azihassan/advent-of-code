import std;

void main()
{
    Point parse(char[] raw)
    {
        Point p;
        raw.formattedRead!"%d,%d"(p.x, p.y);
        return p;
    }
    stdin.byLine.map!parse.array.findFirstDeadEndObstacle(Point(0, 0), Point(70, 70)).writeln();
}

Point findFirstDeadEndObstacle(Point[] obstacles, Point start, Point end)
{
    ulong pivot = 1 + obstacles.length / 2;
    ulong startIndex = 0;
    ulong endIndex = obstacles.length + 1;
    while(startIndex < endIndex)
    {
        pivot = (endIndex + startIndex) / 2;
        long before = obstacles[0 .. pivot - 1].findShortestPath(start, end);
        long current = obstacles[0 .. pivot].findShortestPath(start, end);
        if(before > 0 && current == -1)
        {
            break;
        }
        if(before == -1 && current == -1)
        {
            endIndex = pivot - 1;
        }
        else
        {
            startIndex = pivot + 1;
        }
    }
    return obstacles[pivot - 1];
}

long findShortestPath(Point[] obstacles, Point start, Point end)
{
    bool[Point] obstacleSet;
    foreach(o; obstacles)
    {
        obstacleSet[o] = true;
    }

    Point dimensions = end + Point(1, 1);
    Point[] queue;
    bool[Point] visited;
    long[Point] depth;

    queue ~= start;
    visited[start] = true;
    depth[start] = 0;
    while(!queue.empty)
    {
        Point current = queue.front();
        queue.popFront();
        if(current == end)
        {
            return depth[current];
        }

        foreach(neighbor; current.neighbors)
        {
            if(neighbor in visited || neighbor in obstacleSet || !dimensions.isWithinBounds(neighbor))
            {
                continue;
            }
            visited[neighbor] = true;
            depth[neighbor] = depth[current] + 1;
            queue ~= neighbor;
        }
    }
    return -1;
}

bool isWithinBounds(Point dimensions, Point p)
{
    return 0 <= p.y && p.y < dimensions.y && 0 <= p.x && p.x < dimensions.x;
}

struct Point
{
    int x;
    int y;

    Point distance(Point other) const
    {
        return Point(other.x - x, other.y - y);
    }

    Point[] neighbors() const
    {
        return [
            this + Point(-1, 0), //left/west
            this + Point(0, -1), //up/north
            this + Point(+1, 0), //right/east
            this + Point(0, +1), //down/south
        ];
    }

    Point opBinary(string operator)(Point other) const
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
        return tuple(x, y).hashOf;
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
