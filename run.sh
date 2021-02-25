echo "Cleanup"
rm out/*
echo "Zip code"
zip -r out/code.zip ./lib
echo "Compile"
mix compile
echo "A"
mix process < in/a.txt > out/a.txt
echo "B"
mix process < in/b.txt > out/b.txt
echo "C"
mix process < in/c.txt > out/c.txt
echo "D"
mix process < in/d.txt > out/d.txt
echo "E"
mix process < in/e.txt > out/e.txt
echo "F"
mix process < in/f.txt > out/f.txt
echo "Done"
