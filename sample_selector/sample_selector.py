#!/usr/local/bin/python
import numpy as np
from PIL import Image

def generate_image_matrix():
    filename = open('points', 'r')
    points = []
    for line in filename:
        points.append(line[:-1])
    filename.close()
    vector = np.array(points, dtype=np.uint8)
    matrix = np.reshape(vector, (800, 800))
    return matrix

def get_start_point(matrix):
    start_x = 0
    start_y = 0
    for x in range(800):
        for y in range(800):
            if matrix[x][y] == 1:
                start_x = x
                start_y = y
                break
    return [start_x, start_y]

def draw_polygon(polygon, width, height):
    data = np.zeros( (width, height, 3), dtype=np.uint8)
    for x in range(width):
        for y in range(height):
            if [x, y] in polygon:
                data[x, y] = [255, 0, 0]
    img = Image.fromarray(data, 'RGB')
    img.save('sample.png')

def checkDirection(direction, matrix):
    global current_x
    global current_y
    if direction == 1:
        if matrix[current_x-1, current_y-1] == 1:
            current_x = current_x - 1
            current_y = current_y - 1
            return True
    if direction == 2:
        if matrix[current_x, current_y-1] == 1:
            current_x = current_x
            current_y = current_y - 1
            return True
    if direction == 3:
        if matrix[current_x+1, current_y-1] == 1:
            current_x = current_x + 1
            current_y = current_y - 1
            return True
    if direction == 4:
        if matrix[current_x+1, current_y] == 1:
            current_x = current_x + 1
            current_y = current_y
            return True
    if direction == 5:
        if matrix[current_x+1, current_y+1] == 1:
            current_x = current_x + 1
            current_y = current_y + 1
            return True
    if direction == 6:
        if matrix[current_x, current_y+1] == 1:
            current_x = current_x
            current_y = current_y + 1
            return True
    if direction == 7:
        if matrix[current_x-1, current_y+1] == 1:
            current_x = current_x - 1
            current_y = current_y + 1
            return True
    if direction == 8:
        if matrix[current_x-1, current_y] == 1:
            current_x = current_x - 1
            current_y = current_y
            return True
    return False

def move_to_next(matrix, direction):
    direction = (direction + 3 + 1) % 8 + 1
    for x in range(direction, 9):
        if checkDirection(x, matrix):
            return x
    for x in range(1, direction):
        if checkDirection(x, matrix):
            return x

def traversal_image(interval, matrix):
    global direction
    step = 0
    polygon = []
    start_x = current_x
    start_y = current_y
    while True:
        next_direction = move_to_next(matrix, direction) + 8
        # sample by slope
#        if next_direction != direction:
#            polygon.append([current_x, current_y])
        # sample every interval points
        step = step + 1
        if step % interval == 0:
            polygon.append([current_x, current_y])
        direction = next_direction
        if start_x == current_x and start_y == current_y:
            break
    return polygon

direction = 1
current_x = 0
current_y = 0
interval = 10
image_matrix = generate_image_matrix()
[current_x, current_y] = get_start_point(image_matrix)
polygon = traversal_image(interval, image_matrix)
draw_polygon(polygon, 800, 800)
with open("./sample", "w") as sample:
    for point in polygon:
        sample.write("%d,%d\n" % (point[0], point[1]))
