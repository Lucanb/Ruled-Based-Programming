import tkinter as tk
from tkinter import simpledialog
from tkinter import messagebox
import numpy as np
import time
import rule_engine

def count_ceels(matrix):
    vii = 0
    morti = 0
    for el in matrix:
        for item in el:
            if item == 1:
                vii = vii + 1
            else:
                morti = morti + 1 
    return morti, vii
        
def count_neighbor_values(matrix, x, y):
    num_zeros = 0
    num_ones = 0
    height = len(matrix)
    width = len(matrix[0])

    for i in range(max(0, x - 1), min(x + 2, height)):
        for j in range(max(0, y - 1), min(y + 2, width)):
            if (i, j) != (x, y):
                if matrix[i][j] == 0:
                    num_zeros += 1
                else:
                    num_ones += 1
                    
    eu = 1 if matrix[x, y] == 1 else 0

    return num_zeros, num_ones, eu




class GameOfLife:
    def __init__(self, master, width=20, height=20, cell_size=30):
        self.master = master
        self.width = width
        self.height = height
        self.cell_size = cell_size
        canvas_width = width * cell_size
        canvas_height = height * cell_size
        self.canvas = tk.Canvas(master, width=canvas_width, height=canvas_height)
        self.canvas.pack()
        self.board = np.zeros((height, width), dtype=int)
        self.rects = []
        self.running = False
        self.draw_board()
        self.create_menu()
        self.create_info_labels()
        self.update_info_labels()
        self.canvas.bind("<Button-1>", self.toggle_cell_state)

        control_frame = tk.Frame(master)
        control_frame.pack(side='bottom', fill='x', expand=True)

        self.next_button = tk.Button(control_frame, text="Next Step", command=self.next_generation)
        self.next_button.pack(side='left', padx=10, pady=10)
        self.start_button = tk.Button(control_frame, text="Start/Stop", command=self.start_stop)
        self.start_button.pack(side='left', padx=10, pady=10)
        self.reset_button = tk.Button(control_frame, text="Reset", command=self.reset)
        self.reset_button.pack(side='left', padx=10, pady=10)
        master.geometry(f"{canvas_width+20}x{canvas_height+150}")


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

    def verify_condition(self):
        celule_vii = rule_engine.Rule(
            'vii >= 3'
        )
        dictionar2 = dict()
        morti, vii =  count_ceels(self.board)
        dictionar2["morti"] = morti
        dictionar2["vii"] = vii
        if not celule_vii.matches(dictionar2):
            return False
        else:
            return True

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
                zeros, ones, eu = count_neighbor_values(self.board, i, j)
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

    def reset(self):
        self.running = False 
        self.board = np.zeros((self.height, self.width), dtype=int)
        self.draw_board()
        self.update_info_labels()


    def run_game(self):
        if self.verify_condition():
            while self.running:
                self.next_generation()
                self.master.update()
                time.sleep(0.2)
        else:
            print("Mai putin de 3 celule vii")

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
        resolution_menu.add_command(label="1024x768", command=lambda: self.set_resolution(1024, 768))  # More standard resolution
        resolution_menu.add_command(label="1280x720", command=lambda: self.set_resolution(1280, 720))  # HD resolution
        menubar.add_cascade(label="Set Resolution", menu=resolution_menu)

        random_generate_menu = tk.Menu(menubar, tearoff=0)
        random_generate_menu.add_command(label="Random Generate", command=self.get_random_input)
        menubar.add_cascade(label="Random Generate", menu=random_generate_menu)

        Explanation_menu = tk.Menu(menubar, tearoff=0)
        Explanation_menu.add_command(label="Explanation", command=self.show_explanation)
        menubar.add_cascade(label="Explanation", menu=Explanation_menu)

    def set_resolution(self, width, height):
        self.master.geometry(f"{width}x{height + 50}")  # Adding extra space for buttons
        new_cell_size = min(width // self.width, (height - 50) // self.height)  # Adjust canvas height calculation for buttons
        self.cell_size = new_cell_size
        self.canvas.config(width=self.width * new_cell_size, height=self.height * new_cell_size)
        self.draw_board()
        self.update_info_labels()


    def show_explanation(self):
        explanation_text = """
    Game of Life Explanation
    The Game of Life is not your typical computer game. It is a cellular automaton, and was invented by Cambridge mathematician John Conway.

    This game became widely known when it was mentioned in an article published by Scientific American in 1970. It consists of a grid of cells which, based on a few mathematical rules, can live, die or multiply. Depending on the initial conditions, the cells form various patterns throughout the course of the game.

    Rules
    For a space that is populated:
    - Each cell with one or no neighbors dies, as if by solitude.
    - Each cell with four or more neighbors dies, as if by overpopulation.
    - Each cell with two or three neighbors survives.

    For a space that is empty or unpopulated:
    - Each cell with three neighbors becomes populated.
    """
        messagebox.showinfo("Explanation", explanation_text)

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
    root.mainloop()

    root.mainloop()