package backend;

class FilePaths {
    inline static public function engineImage(key:String, ?ext:String = 'png') {
        return buildPath('images/$key.$ext');
    }

    inline static public function engineFont(key:String, ?ext:String = 'ttf') {
        return buildPath('fonts/$key.$ext');
    }

    inline static public function engineSound(key:String, ?ext:String = 'ogg') {
        return buildPath('sound/$key.$ext');
    }


    inline static public function buildPath(path:String) {
        return 'assets/$path'; 
    }
}