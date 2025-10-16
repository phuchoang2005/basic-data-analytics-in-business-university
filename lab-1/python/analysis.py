import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import skew, kurtosis

def calculate_statistics(df, column):
    """Calculate descriptive statistics for a numeric column."""
    data = df[column].dropna()
    
    stats = {
        "mean": data.mean(),
        "median": data.median(),
        "mode": data.mode().tolist(),
        "quartiles": data.quantile([0.25, 0.5, 0.75]),
        "variance": data.var(),
        "std_dev": data.std(),
        "range": data.max() - data.min(),
        "sem": data.sem(),
        "skewness": skew(data, bias=False),
        "kurtosis": kurtosis(data, bias=False)
    }
    return stats


def visualize_histogram(data, column, mean, median):
    """Plot histogram with mean and median lines."""
    plt.figure(figsize=(8, 5))
    plt.hist(data, bins=10, edgecolor='black', alpha=0.7)
    plt.axvline(mean, color='red', linestyle='dashed', linewidth=1.5, label=f'Mean: {mean:.2f}')
    plt.axvline(median, color='green', linestyle='dotted', linewidth=1.5, label=f'Median: {median:.2f}')
    plt.title(f"Histogram of {column}")
    plt.xlabel(column)
    plt.ylabel("Frequency")
    plt.legend()
    plt.show()


def visualize_boxplot(data, column):
    """Plot box plot of the column."""
    plt.figure(figsize=(6, 5))
    plt.boxplot(data, vert=True, patch_artist=True)
    plt.title(f"Box Plot of {column}")
    plt.ylabel(column)
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    plt.show()


# --- MAIN PROGRAM ---
if __name__ == "__main__":
    csv_file = "VNZ_STOCK_DATA_AUGUST.csv"  # Change to your file name
    df = pd.read_csv(csv_file)

    column = "Total Value"  # Change to the numeric column you want to analyze
    data = df[column].dropna()

    stats = calculate_statistics(df, column)

    # --- Print Results ---
    print(f"Descriptive Statistics for '{column}':")
    print("-" * 50)
    print(f"Mean: {stats['mean']}")
    print(f"Median: {stats['median']}")
    print(f"Mode: {stats['mode']}")
    print(f"Quartiles:\n{stats['quartiles']}\n")
    print("--- Dispersion ---")
    print(f"Variance: {stats['variance']}")
    print(f"Standard Deviation: {stats['std_dev']}")
    print(f"Range: {stats['range']}")
    print(f"Standard Error of Mean: {stats['sem']}\n")
    print("--- Shape ---")
    print(f"Skewness: {stats['skewness']}")
    print(f"Kurtosis: {stats['kurtosis']}")

    # --- Visualizations ---
    visualize_histogram(data, column, stats['mean'], stats['median'])
    visualize_boxplot(data, column)
