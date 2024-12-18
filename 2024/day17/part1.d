import std;

void main()
{
    auto computer = Computer();
    readln().formattedRead!"Register A: %d"(computer.registers["A"]);
    readln().formattedRead!"Register B: %d"(computer.registers["B"]);
    readln().formattedRead!"Register C: %d"(computer.registers["C"]);
    readln();

    string program;
    readln().formattedRead!"Program: %s"(program);
    computer.run(program.strip().splitter(",").map!(to!int).array).map!(to!string).joiner(",").writeln();
}

struct Computer
{
    int[string] registers = ["A": 0, "B": 0, "C": 0];
    ulong pc;

    int resolveOperand(int operand)
    {
        if(operand == 4)
        {
            return registers["A"];
        }
        if(operand == 5)
        {
            return registers["B"];
        }
        if(operand == 6)
        {
            return registers["C"];
        }
        return operand;
    }

    int[] run(int[] program)
    {
        pc = 0;
        int[] output;
        while(pc < program.length)
        {
            int operand = program[pc + 1];
            switch(program[pc])
            {
                case 0: //adv
                    registers["A"] /= cast(int)(2 ^^ resolveOperand(program[pc + 1]));
                    pc += 2;
                    break;
                case 1: //bxl
                    registers["B"] ^= resolveOperand(program[pc + 1]);
                    pc += 2;
                    break;
                case 2: //bst
                    registers["B"] = resolveOperand(program[pc + 1]) % 8;
                    pc += 2;
                    break;
                case 3: //jnz
                    if(registers["A"] == 0)
                    {
                        pc += 2;
                    }
                    else
                    {
                        pc = resolveOperand(program[pc + 1]);
                    }
                    break;
                case 4: //bxc
                    registers["B"] ^= registers["C"];
                    pc += 2;
                    break;
                case 5: //out
                    output ~= resolveOperand(program[pc + 1]) % 8;
                    pc += 2;
                    break;
                case 6:
                    registers["B"] = registers["A"] / cast(int)(2 ^^ resolveOperand(program[pc + 1]));
                    pc += 2;
                    break;
                case 7:
                    registers["C"] = registers["A"] / cast(int)(2 ^^ resolveOperand(program[pc + 1]));
                    pc += 2;
                    break;
                default:
                    pc += 2;
                    break;
            }
        }
        return output;
    }
}
