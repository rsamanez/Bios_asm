from PIL import Image
def rgb_of_pixel(img_path, x, y):
    im = Image.open(img_path).convert('RGB')
    r, g, b = im.getpixel((x, y))
    a = (r, g, b)
    return r

numbers = []
mt = []
for e in range(10):
    for i in range(89):
        mt.append([0,0,0,0,0,0])
    numbers.append(mt)
    mt=[]
for p in range(10):    
    for y in range(89):
        for x in range(48):
            n = rgb_of_pixel("number"+str(p)+".png", x,y)
            if n == 78:
                w = x % 8
                q = x // 8
                v = 2**w
                numbers[p][y][q] += v
# print(numbers[1])
newFile = open("numbers.bin", "wb")
newFileBytes = []
num = 0
for p in range(10):    
    for y in range(89):
        for x in range(6):
            newFileBytes.append(numbers[p][y][x])
            num += 1
for i in range(292):
    newFileBytes.append(0)
    num += 1
print(num,"Bytes")
newFileByteArray = bytearray(newFileBytes)
newFile.write(newFileByteArray)
