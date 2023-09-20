use std::{path::Path, process::{exit, Command}};

use wallpapers::{get_wallpaper_dir, get_random_img_path_string};

fn main() {
    let dir: String = get_wallpaper_dir();

    let path = Path::new(&dir);
    if !path.is_dir() {
        eprintln!("Invalid wallpaper path {}", dir);
        exit(1);
    }

    let chosen_image = get_random_img_path_string(&path);

    println!("Random image is: {chosen_image}");

    Command::new("feh")
            .arg("--bg-fill")
            .arg(chosen_image)
            .output()
            .expect("Failed to executed feh");
}
