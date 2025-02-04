// MyProgram.cpp
import Common;
import Chunk;

using namespace std;

int main()
{
	uint8_t a = 10;
	auto c = chunk::Chunk{ .code = &a };
	printf("code is %p", &a);
	return 0;
}