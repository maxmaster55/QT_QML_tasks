#pragma once
#include <iostream>

using std::string;
using std::to_string;


typedef enum{
    mode_read,
    mode_write
} pin_mode_t;



class mypin
{
private:
    pin_mode_t mode;
    int fd;
    int pin_num;
public:
    mypin() = default;
    mypin(int num, pin_mode_t _mode);

    mypin(const mypin&) = delete;
    mypin& operator=(const mypin&) = delete;

    mypin(mypin&&) noexcept;
    mypin& operator=(mypin&&) noexcept;
    
    void operator<<(int val);
    void operator>>(int& val);
};

