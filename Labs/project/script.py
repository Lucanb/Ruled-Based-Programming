import tkinter as tk
from tkinter import simpledialog
import numpy as np
import time
import rule_engine

def count_neighbor_values(matrix, x, y):
    num_zeros = 0
    num_ones = 0
    height = len(matrix[0])
    width = len(matrix)

    min_x = max(0, x - 1)
    max_x = min(width - 1, x + 1)
    min_y = max(0, y - 1)
    max_y = min(height - 1, y + 1)

    for i in range(min_y, max_y + 1):
        for j in range(min_x, max_x + 1):
            if (i, j) != (y, x):
                if matrix[i][j] == 0:
                    num_zeros += 1
                else:
                    num_ones += 1

    if matrix[x,y] == 1:
        eu = 1
    else:   
        eu = 0

    return num_zeros, num_ones, eu

class GameOfLife:
    def __init__(self, master, width=20, height=20, cell_size=10):
        self.master = master
        self.width = width
        self.height = height
        self.cell_size = cell_size
        self.canvas = tk.Canvas(master, width=width*cell_size, height=height*cell_size)
        self.canvas.pack()
        self.board = np.zeros((height, width), dtype=int)
        self.rects = []
        self.running = False
        self.draw_board()
        self.create_menu()
        self.create_info_labels()
        self.update_info_labels()
        self.canvas.bind("<Button-1>", self.toggle_cell_state)

    def draw_board(self):
        self.canvas.delete("all")
        self.rects = []
        for y in range(self.height):
            row = []
            for x in range(self.width):
                if self.board[y][x] == 1:
                    rect = self.canvas.create_rectangle(x*self.cell_size, y*self.cell_size,
                                                        (x+1)*self.cell_size, (y+1)*self.cell_size,
                                                        fill="black")
                    row.append(rect)
                else:
                    rect = self.canvas.create_rectangle(x*self.cell_size, y*self.cell_size,
                                                        (x+1)*self.cell_size, (y+1)*self.cell_size,
                                                        fill="white")
                    row.append(rect)
            self.rects.append(row)

    def toggle_cell_state(self, event):
        if not self.running:
            x = event.x // self.cell_size
            y = event.y // self.cell_size
            self.board[y][x] = 1 if self.board[y][x] == 0 else 0
            self.draw_board()
            self.update_info_labels()

    def next_generation(self):
        moare1 = rule_engine.Rule(
            'vii < 2 and eu == 1' 
        )
        moare2 = rule_engine.Rule(
            'vii > 3 and eu == 1' 
        )
        traieste1 = rule_engine.Rule(
            'vii > 1 and vii < 4 and eu == 1'
        )
        traieste2 = rule_engine.Rule(
            'vii == 3 and eu == 0'
        )
        new_board = np.copy(self.board)
        height, width = new_board.shape
        dictionar = dict()
        for i in range(height):
            for j in range(width):
                zeros, ones, eu = count_neighbor_values(new_board, i, j)
                dictionar["vii"] = ones
                dictionar["morti"] = zeros
                dictionar["eu"] = eu
                if moare1.matches(dictionar) or moare2.matches(dictionar):
                    new_board[i][j] = 0
                elif traieste1.matches(dictionar) or traieste2.matches(dictionar):
                    new_board[i][j] = 1
        self.board = new_board
        self.draw_board()
        self.update_info_labels()

    def start_stop(self):
        if not self.running:
            self.running = True
            self.run_game()
        else:
            self.running = False

    def run_game(self):
        while self.running:
            self.next_generation()
            self.master.update()
            time.sleep(0.2)

    def create_menu(self):
        menubar = tk.Menu(self.master)
        self.master.config(menu=menubar)

        dim_menu = tk.Menu(menubar, tearoff=0)
        dim_menu.add_command(label="20x20", command=lambda: self.set_dimensions(20, 20))
        dim_menu.add_command(label="30x30", command=lambda: self.set_dimensions(30, 30))
        dim_menu.add_command(label="40x40", command=lambda: self.set_dimensions(40, 40))
        menubar.add_cascade(label="Set Dimensions", menu=dim_menu)

        resolution_menu = tk.Menu(menubar, tearoff=0)
        resolution_menu.add_command(label="800x600", command=lambda: self.set_resolution(800, 600))
        resolution_menu.add_command(label="1200x800", command=lambda: self.set_resolution(1200, 800))
        resolution_menu.add_command(label="1600x1200", command=lambda: self.set_resolution(1600, 1200))
        menubar.add_cascade(label="Set Resolution", menu=resolution_menu)

        random_generate_menu = tk.Menu(menubar, tearoff=0)
        random_generate_menu.add_command(label="Random Generate", command=self.get_random_input)
        menubar.add_cascade(label="Random Generate", menu=random_generate_menu)

    def get_random_input(self):
        num_live_cells = simpledialog.askinteger("Input", "Enter the number of live cells:", parent=self.master)
        if num_live_cells is not None:
            self.random_generate(num_live_cells)

    def random_generate(self, num_live_cells):
        max_live_cells = self.width * self.height
        num_live_cells = min(num_live_cells, max_live_cells)
        indices = np.random.choice(max_live_cells, num_live_cells, replace=False)
        self.board = np.zeros((self.height, self.width), dtype=int)
        for index in indices:
            x = index % self.width
            y = index // self.width
            self.board[y][x] = 1
        self.draw_board()
        self.update_info_labels()

    def set_resolution(self, width, height):
        self.master.geometry(f"{width}x{height}")
        self.canvas.config(width=width, height=height)
        self.cell_size = min(width // self.width, height // self.height)
        self.draw_board()
        self.update_info_labels()

    def create_info_labels(self):
        self.live_label = tk.Label(self.master, text="Live cells: 0")
        self.live_label.pack()
        self.dead_label = tk.Label(self.master, text="Dead cells: 0")
        self.dead_label.pack()

    def update_info_labels(self):
        live_count = np.count_nonzero(self.board)
        dead_count = self.width * self.height - live_count
        self.live_label.config(text=f"Live cells: {live_count}")
        self.dead_label.config(text=f"Dead cells: {dead_count}")

    def set_dimensions(self, width, height):
        self.width = width
        self.height = height
        self.board = np.zeros((height, width), dtype=int)
        self.canvas.config(width=width*self.cell_size, height=height*self.cell_size)
        self.draw_board()
        self.update_info_labels()

if __name__ == "__main__":
    root = tk.Tk()
    game = GameOfLife(root)

    start_button = tk.Button(root, text="Start/Stop", command=game.start_stop)
    start_button.pack()

    root.mainloop()
