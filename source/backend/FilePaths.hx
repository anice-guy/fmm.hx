package backend;

public static var curLevel:String = 'default'

class FilePaths {
    inline static public function getPath(path:String) {
        return 'assets/$path'; 
    }

    inline static public function getLevelPath(path:String) {
        return 'levels/$curLevel/$path'; 
    }
}