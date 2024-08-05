function gradle --wraps=./gradlew --description 'swaps ./gradlew for gradle'
    if test -e ./gradlew
        ./gradlew $argv
    else
        echo "No gradlew found"
    end
end
