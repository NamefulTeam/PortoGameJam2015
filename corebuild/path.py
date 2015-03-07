import os
import os.path

class NoLoveInstalledException(Exception):
    pass

def get_love_executable():
    return 'C:/Program Files/LOVE/love.exe'

def get_auxiliary_files():
    lua_executable = get_love_executable()
    lua_folder = os.path.dirname(lua_executable)
    files = os.listdir(lua_folder)

    files_to_remove = ['game.ico', 'love.ico', 'love.exe', 'changes.txt', 'readme.txt', 'Uninstall.exe', 'license.txt']
    files_to_use = []

    for candidate_file in files:
        if candidate_file not in files_to_remove:
            files_to_use.append((candidate_file, os.path.join(lua_folder, candidate_file)))

    return files_to_use
