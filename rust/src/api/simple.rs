// this function is exposed to flutter and runs synchronously
// this takes an integer and returns its square (number * number = number ^ 2 you know)
#[flutter_rust_bridge::frb(sync)]
pub fn square(num: i32) -> i32 {
    num * num
}

// this function is called once to initialize the rust bridge
// it's required by flutter_rust_bridge to set up internal utilities
#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
