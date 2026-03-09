package backend;

class FilePaths {
    inline static public function getImage(key:String, ?ext:String = 'png') {
        return buildPath('images/$key.$ext');
    }

    inline static public function getFont(key:String, ?ext:String = 'ttf') {
        return buildPath('fonts/$key.$ext');
    }

    inline static public function getSound(key:String, ?ext:String = 'ogg') {
        return buildPath('sounds/$key.$ext');
    }

    inline static public function buildPath(path:String) {
        return 'assets/$path'; 
    }
}