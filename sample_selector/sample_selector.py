#!/usr/local/bin/python
import numpy as np
import math
import sys
from PIL import Image

def get_polygon_from_file(input_file):
    polygon = {}
    filename = open(input_file, 'r')
    points = []
    for line in filename:
        polygon[tuple(map(int, line[:-1].split(" ")))] = True
    filename.close()
    return polygon

def get_init_points(polygon):
    sorted_tuples = sorted(polygon.keys(), key=lambda tup: tup[0])
    start = sorted_tuples[0]
    end = sorted_tuples[-1]
    return [start, end]

def draw_polygon(points, output_file):
    data = np.zeros( (800, 800, 3), dtype=np.uint8)
    for x in range(800):
        for y in range(800):
            if (x, y) in points:
                data[x, y] = [255, 0, 0]
    img = Image.fromarray(data, 'RGB')
    img.save(output_file)

def checkDirection(direction, border):
    global delta
    global polygon
    p = border[-1]
    (deltax, deltay) = delta[direction]
    if (p[0] + deltax, p[1] + deltay) in polygon:
        border.append((p[0] + deltax, p[1] + deltay))
        return True
    return False

def move_to_next(border):
    global direction
    direction = (direction + 4 + 1) % 8
    for x in range(direction, direction+7):
        if checkDirection(x%8, border):
            direction = x
            return

def get_border(p1):
    global direction
    border = []
    border.append(p1)
    while True:
        move_to_next(border)
        if (border[-1] == p1):
            break
    return border

def compute_distance(p1, p2):
    return (p1[0]-p2[0])**2 + (p1[1]-p2[1])**2

#TODO : make it more efficient
def compute_square(p0, p1, p2, d):
    d01 = math.sqrt(compute_distance(p1, p0))
    d02 = math.sqrt(compute_distance(p2, p0))
    d12 = math.sqrt(d)
    p = (d01 + d02 + d12)/2
    return abs(p*(p-d01)*(p-d02)*(p-d12))

def find_the_farest_point(start, end):
    global threshold
    global border
    max_h = 0
    index = start + 1
    d = compute_distance(border[start], border[end])
    for x in range(start+1, end):
        height = compute_square(border[x], border[start], border[end], d) * 4 / d
        if max_h < height:
            max_h = height
            index = x
    if threshold < max_h:
        return index
    return start

def recursive_splitting(start, middle, end):
    global sample
    index = find_the_farest_point(start, middle)
    if (index != start):
        sample.append(index)
        recursive_splitting(start, index, middle)

    index = find_the_farest_point(middle, end)
    if (index != middle):
        sample.append(index)
        recursive_splitting(middle, index, end)

def get_points_from_index(sample, border):
    points = []
    for index in sample:
        points.append(border[index])
    return points

if __name__ == "__main__":
    delta = {0:(-1,-1), 1:(0,-1), 2:(1,-1), 3:(1,0), 4:(1,1), 5:(0,1), 6:(-1,1), 7:(-1,0)}

    input_file = sys.argv[1]
    polygon = get_polygon_from_file(input_file)

    direction = 5
    [p1, p2] = get_init_points(polygon)
    border = get_border(p1)

    sample = []
    start = 0
    middle = border.index(p2)
    end = len(border)-1
    sample.extend([start, middle, end])

    threshold = int(sys.argv[2]) ** 2
    recursive_splitting(start, middle, end)

    sample = sorted(sample)
    points = get_points_from_index(sample, border)
    for point in points:
        print point

    #draw_polygon(polygon, "polygon.png")
    #draw_polygon(border, "border.png")
    #draw_polygon(points, "sample.png")
