// Example.ixx
export module Chunk;

import <cstdint>;
import <cstdlib>;

namespace chunk {

	export enum OpCode {
		OP_RETURN,

	};

	export struct Chunk {
		int count;
		int capacity;
		uint8_t* code;
	};
}
