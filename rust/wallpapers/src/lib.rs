use std::{process::exit, path::Path, fs::DirEntry};

use rand::Rng;

pub fn get_wallpaper_dir() -> String {
    let home_dir = std::env::var("HOME").unwrap_or_else(|e| {
        eprintln!("$HOME not set - {:?}", e);
        exit(1);
    });
    home_dir + "/.dotfiles/.wallpaper/"
}

pub fn get_random_img_path_string(path: &Path) -> String { 
    let random_idx = rand::thread_rng().gen_range(0..path.read_dir().unwrap().count());

    let v: Vec<DirEntry> = path.read_dir().unwrap()
                    .map(|entry| entry.unwrap())
                    .collect();
    
    let chosen = v.get(random_idx).unwrap().path().to_str().unwrap().to_string();

    chosen
}