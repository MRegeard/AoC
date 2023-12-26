from trebuchet import get_sum, get_sum_letters


def test_get_sum():
    text = '1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet\n'
    line_1 = '1abc2'
    line_last = 'treb7uchet'
    assert get_sum(text) == 142
    assert get_sum(line_1) == 12
    assert get_sum(line_last) == 77


def test_get_sum_letters():
    text = "two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen"
    line_1 = "two1nine"
    line_last = "7pqrstsixteen"
    assert get_sum_letters(text) == 281
    assert get_sum_letters(line_1) == 29
    assert get_sum_letters(line_last) == 76


if __name__ == '__main__':
    test_get_sum()
    test_get_sum_letters()