// Run your program with: 
// dmd Deque.d -unittest -of=test && ./test
//
// This will execute each of the unit tests telling you if they passed.

module deque;

import std.exception;
import core.exception : AssertError;

/*
    The following is an interface for a Deque data structure.
    Generally speaking we call these containers.
    
    Observe how this interface is a templated (i.e. Container(T)),
    where 'T' is a placeholder for a data type.
*/
interface Container(T){
    // Element is on the front of collection
    void push_front(T x);

    // Element is on the back of the collection
    void push_back(T x);

    // Element is removed from front and returned
    // assert size > 0 before operation
    T pop_front();

    // Element is removed from back and returned
    // assert size > 0 before operation
    T pop_back();

    // Retrieve reference to element at position at index
    // assert pos is between [0 .. $] and size > 0
    ref T at(size_t pos);

    // Retrieve reference to element at back of position
    // assert size > 0 before operation
    ref T back();

    // Retrieve element at front of position
    // assert size > 0 before operation
    ref T front();

    // Retrieve number of elements currently in container
    size_t size();
}

/*
    A Deque is a double-ended queue in which we can push and
    pop elements.
    
    Note: Remember we could implement Deque as either a class or
          a struct depending on how we want to extend or use it.
          Either is fine for this assignment.
    
    Dynamic Array approach
*/
class Deque(T) : Container!(T) {
    T[] mData;

    override void push_front(T x) {
        auto front = [x];
        front ~= mData;
        this.mData = front;
    }

    override void push_back(T x) {
        this.mData ~= x;
    }

    override T pop_front() {
        assert(this.mData.length > 0);
        auto res = this.mData[0];
        this.mData = this.mData[1..$];
        return res;
    }

    override T pop_back() {
        assert(this.mData.length > 0);
        auto res = this.mData[$-1];
        this.mData = this.mData[0..$-1];
        return res;
    }

    override ref T at(size_t pos) {
        assert(this.mData.length > 0 && (pos >= 0 && pos <= this.mData.length -1));
        return this.mData[pos];
    }

    override ref T back() {
        assert(this.mData.length > 0);
        return this.mData[$-1];
    }

    override ref T front() {
        assert(this.mData.length > 0);
        return this.mData[0];
    }

    override size_t size() {
        return this.mData.length;
    }
}

// An example unit test that you may consider.
// Try writing more unit tests in separate blocks
// and use different data types.
unittest {
    auto myDeque = new Deque!(int);
    myDeque.push_front(1);
    auto element = myDeque.pop_front();
    assert(element == 1);
}

unittest {
    auto myDeque = new Deque!(int);
    myDeque.push_front(1);
    myDeque.push_front(2);
    auto element = myDeque.pop_back();
    assert(element == 1);
    myDeque.push_front(1);
    assert(myDeque.pop_front() == 1);
}

unittest {
    auto myDeque = new Deque!(string);
    myDeque.push_back("1");
    myDeque.push_back("2");
    assert(myDeque.pop_back() == "2");
    assert(myDeque.pop_back() == "1");
    assert(myDeque.size() == 0);
}

unittest {
    auto myDeque = new Deque!(int);
    for (int i = 0; i < 20; i++) {
        myDeque.push_back(i);
    }
    for (int i = 0; i < 20; i++) {
        assert(myDeque.at(i) == i);
    }
    assert(myDeque.front() == 0);
    assert(myDeque.back() == 19);
}

unittest {
    auto myDeque = new Deque!(int);
    for (int i = 0; i < 20; i++) {
        assert(myDeque.size() == i);
        myDeque.push_front(i);
    }
}

unittest {
    auto myDeque = new Deque!(bool);
    myDeque.push_back(true);
    assert(&myDeque.at(0) == &myDeque.back());
    assert (&myDeque.at(0) == &myDeque.front());
}

unittest {
    auto myDeque = new Deque!(int);
    assertThrown!AssertError(myDeque.front());
}

unittest {
    auto myDeque = new Deque!(int);
    assertThrown!AssertError(myDeque.back());
}

unittest {
    auto myDeque = new Deque!(int);
    assertThrown!AssertError(myDeque.pop_back());
}

unittest {
    auto myDeque = new Deque!(int);
    assertThrown!AssertError(myDeque.pop_front());
}

unittest {
    auto myDeque = new Deque!(int);
    assertThrown!AssertError(myDeque.at(0));
}

unittest {
    auto myDeque = new Deque!(int);
    myDeque.push_front(1);
    assertThrown!AssertError(myDeque.at(4));
}
