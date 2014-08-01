#!/usr/local/bin/python
import numpy as np
from PIL import Image

def get_polygon_from_file():
    polygon = {}
    filename = open('points', 'r')
    points = []
    for line in filename:
        polygon[tuple(map(int, line[:-1].split(" ")))] = True
    filename.close()
    return polygon

def draw_polygon(polygon, width, height):
    data = np.zeros( (width, height, 3), dtype=np.uint8)
    for x in range(width):
        for y in range(height):
            if (x, y) in polygon:
                data[x, y] = [255, 0, 0]
    img = Image.fromarray(data, 'RGB')
    img.save('sample.png')

def checkDirection(direction):
    global p_x
    global p_y
    global polygon
    if direction == 1:
        if (p_x-1, p_y-1) in polygon:
            p_x = p_x - 1
            p_y = p_y - 1
            return True
    if direction == 2:
        if (p_x, p_y-1) in polygon:
            p_x = p_x
            p_y = p_y - 1
            return True
    if direction == 3:
        if (p_x+1, p_y-1) in polygon:
            p_x = p_x + 1
            p_y = p_y - 1
            return True
    if direction == 4:
        if (p_x+1, p_y) in polygon:
            p_x = p_x + 1
            p_y = p_y
            return True
    if direction == 5:
        if (p_x+1, p_y+1) in polygon:
            p_x = p_x + 1
            p_y = p_y + 1
            return True
    if direction == 6:
        if (p_x, p_y+1) in polygon:
            p_x = p_x
            p_y = p_y + 1
            return True
    if direction == 7:
        if (p_x-1, p_y+1) in polygon:
            p_x = p_x - 1
            p_y = p_y + 1
            return True
    if direction == 8:
        if (p_x-1, p_y) in polygon:
            p_x = p_x - 1
            p_y = p_y
            return True
    return False

def move_to_next(direction):
    direction = (direction + 3 + 1) % 8 + 1
    for x in range(direction, 9):
        if checkDirection(x):
            return x
    for x in range(1, direction):
        if checkDirection(x):
            return x

def traversal_image(interval):
    global direction
    step = 0
    points = []
    start_x = p_x
    start_y = p_y
    while True:
        next_direction = move_to_next(direction) + 8
        # sample by slope
#        if next_direction != direction:
#            points.append((p_x, p_y))
        # sample every interval points
        step = step + 1
        if step % interval == 0:
            points.append((p_x, p_y))
        direction = next_direction
        if start_x == p_x and start_y == p_y:
            break
    return points

direction = 1
interval = 1
polygon = get_polygon_from_file()
draw_polygon(polygon, 800, 800)
(p_x, p_y) = polygon.keys()[0]
#points = traversal_image(interval)
#draw_polygon(points, 800, 800)
#with open("./sample", "w") as sample:
#    sample.write('\n'.join('%d %d' % p for p in points))
